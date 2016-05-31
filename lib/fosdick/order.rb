module Fosdick
  class Order
    include Virtus.model(:nullify_blank => true, :strict => true)

    module OrderTypes
      ALL = [
        WEB = 'WEB'.freeze,
        PHONE = 'PHONE'.freeze,
      ]
    end.freeze

    module Countries
      ALL = [
        US = 'US'.freeze
      ]
    end

    attribute :client_code, String,
      default: lambda { |_order, _att| Fosdick.configuration.client_code }

    attribute :test, String,
      default: lambda { |_order, _att| Fosdick.configuration.test_mode? ? "Y" : "N" }

    attribute :subtotal, Money # subtotal of line items
    attribute :discounts, Money, default: 0 # discount applied to subtotal (negative value)
    attribute :postage, Money, default: 0 # postage paid
    attribute :tax, Money, default: 0 # tax paid
    attribute :total, Money, required: false # subtotal + discounts + postage + tax

    attribute :external_id, String, required: false
    attribute :order_date, DateTime, required: false # eastern time
    attribute :order_type, String, default: OrderTypes::WEB
    attribute :ad_code, String # primary tracking code
    attribute :source_code, String, required: false # secondary tracking code

    attribute :items, Array[LineItem]

    attribute :shipping_method, String, required: false
    attribute :ship_firstname, String
    attribute :ship_lastname, String
    attribute :ship_address1, String
    attribute :ship_address2, String, required: false
    attribute :ship_address3, String, required: false
    attribute :ship_city, String
    attribute :ship_state, String
    attribute :ship_state_other, String, required: false # province (if ship_state is blank)
    attribute :ship_zip, String
    attribute :ship_country, String, default: Countries::US
    attribute :ship_phone, String, required: false
    attribute :ship_fax, String, required: false

    attribute :email, String, required: true
    attribute :use_as_billing, String, required: false

    attribute :bill_firstname, String, required: false
    attribute :bill_lastname, String, required: false
    attribute :bill_address1, String, required: false
    attribute :bill_address2, String, required: false
    attribute :bill_address3, String, required: false
    attribute :bill_city, String, required: false
    attribute :bill_state, String, required: false
    attribute :bill_state_other, String, required: false # province (if bill_state is blank)
    attribute :bill_zip, String, required: false
    attribute :bill_country, String, default: Countries::US, required: false
    attribute :bill_phone, String, required: false

    attribute :kid_name, String

    attribute :custom1, String, required: false # 100 chars
    attribute :custom2, String, required: false # 100 chars
    attribute :custom3, String, required: false # 300 chars
    attribute :custom4, String, required: false # 300 chars
    attribute :custom5, String, required: false # 300 chars

    attribute :payment_type, String

    # Credit card
    # attribute :cc_number, String
    # attribute :cc_month, Integer
    # attribute :cc_year, Integer
    # attribute :ccv, String
    # attribute :cc_auth_descriptor, String
    # attribute :cc_auth_phone, String

    # Credit card pre-auth
    attribute :cc_auth_code, String, required: false
    attribute :cc_auth_txid, String, required: false
    attribute :cc_auth_date, Date, required: false
    attribute :cc_auth_amount, Money, required: false
    attribute :cc_auth_order_id, String, required: false
    attribute :cc_auth_cvv, String, required: false # CVV match code
    attribute :cc_failed_auth, Boolean, required: false

    # PayPal
    attribute :pp_payer_id, String, required: false
    attribute :pp_transaction_id, String, required: false
    attribute :pp_token_id, String, required: false

    # Amazon Payments
    attribute :amz_token, String, required: false
    attribute :amz_auth_date, Date, required: false
    attribute :amz_auth_amount, Money, required: false

    def create
      payload = build_payload
      response = post(payload)

      if /^True\|/ =~ response.body
        handle_success(response)
      else
        handle_error(response)
      end
    end

    def build_payload
      payload = attributes.delete_if { |k, v| v.nil? }

      # handle order line items
      items = payload.delete(:items)
      payload[:items] = items.count
      payload = payload.merge(build_items(items))

      # convert keys from snake_case to CamelCase
      payload = payload.map { |k, v| [camelize(k), v] }

      URI.encode_www_form payload
    end

    private

    def camelize(attribute)
      attribute.to_s.split('_').map { |w| w.capitalize }.join
    end

    def build_items(items)
      new_items = {}
      items.each_with_index do |item, i|
        item.attributes.map {|k,v| new_items["#{k}#{i + 1}"] = v}
      end
      new_items
    end

    def handle_success(response)
      data = response.body.split("|")
      { external_id: data[1], order_id: data[2] }
    end

    def handle_error(response)
      errors = response.body.split("|").compact.slice(3, 2)
      case errors[0]
      when "Invalid"
        raise InvalidError, errors.last
      when "Auth"
        raise AuthenticationError, errors.last
      else
        raise FailureError, errors.last
      end
    end

    def post(payload)
      conn.post do |req|
        req.body = payload
      end
    end

    def conn
      Faraday.new(url: "https://www.unitycart.com/#{configuration.client_name}/cart/ipost.asp") do |faraday|
        # faraday.response :logger # log requests to STDOUT
        faraday.request :url_encoded
        faraday.basic_auth(configuration.username, configuration.password)
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
    end

    def configuration
      Fosdick.configuration
    end
  end
end
