require "spec_helper"

describe Fosdick::Order do
  before do
    @attributes = {
      email: "test@test.net",
      external_id: "5587",
      subtotal: 7.0,
      ad_code: "ECOMM",
      ship_firstname: "Bruce",
      ship_lastname: "Wayne",
      ship_address1: "12 Manor Drive",
      ship_city: "Woodland Hills",
      ship_state: "NY",
      ship_zip: "11223",
      bill_firstname: "Lucius",
      bill_lastname: "Fox",
      bill_address1: "33 Wayne Ent Drive",
      bill_city: "Woodland Hills",
      bill_state: "NY",
      bill_zip: "11332",
      payment_type: 5,
      items: [
        { inv: "sku-1", qty: 3, price_per: 1, num_of_payments: 1 },
        { inv: "sku-3", qty: 2, price_per: 2, num_of_payments: 1 }
      ],
      total: 7.0,
      custom_fields: { KID_NAME: "Sam", SUPERHERO: "Batman", BlAh: 3 }
    }

    Fosdick.configure do |config|
      config.client_name = 'test'
    end
  end

  context "build_payload" do
    before do
      order = Fosdick::Order.new(@attributes)
      @payload = order.build_payload
    end

    it "has all the basic fields truncated and form-encoded" do
      expect(@payload).to have_form_encoded(
        "Email" => "test@test.net",
        "ExternalId" => "5587",
        "Subtotal" => 7.0,
        "Total" => 7.0,
        "AdCode" => "ECOMM",
        "ShipFirstname" => "Bruce",
        "ShipLastname" => "Wayne",
        "ShipAddress1" => "12 Manor Drive",
        "ShipCity" => "Woodland Hill",
        "ShipState" => "NY",
        "ShipZip" => "11223",
        "BillFirstname" => "Lucius",
        "BillLastname" => "Fox",
        "BillAddress1" => "33 Wayne Ent Drive",
        "BillCity" => "Woodland Hill",
        "BillState" => "NY",
        "BillZip" => "11332",
        "PaymentType" => 5,
      )
    end

    it "includes form-encoded default client code and test flag" do
      expect(@payload).to have_form_encoded(
        "ClientCode" => Fosdick.configuration.client_code,
        "Test" => "Y"
      )
    end

    it "has line items form-encoded" do
      expect(@payload).to have_form_encoded(
        "Items" => 2,
        "Inv1" => "sku-1",
        "Qty1" => 3,
        "Inv2" => "sku-3",
        "Qty2" => 2,
      )
    end

    it "has custom fields--appended unaltered to--'Custom_'" do
      expect(@payload).to have_form_encoded(
        "Custom_KID_NAME" => "Sam",
        "Custom_SUPERHERO" => "Batman",
        "Custom_BlAh" => 3
      )
    end
  end

  context "given a valid order" do
    it "POSTs the order to Fosdick", vcr: { record: :none, cassette_name: "orders/create#valid" } do
      result = Fosdick::Order.new(@attributes).create
      expect(result[:external_id]).to eq("5587")
    end

    it "returns a an order id from fosdick", vcr: { record: :none, cassette_name: "orders/create#valid" } do
      result = Fosdick::Order.new(@attributes).create
      expect(result[:order_id]).to_not be_nil
    end
  end

  context "given an invalid order" do
    it "does not post to fosdick", vcr: { record: :none, cassette_name: "orders/create#invalid" } do
      @attributes[:external_id] = 1233
      @attributes.delete(:ship_firstname)
      @attributes.delete(:ship_lastname)
      expect { Fosdick::Order.new(@attributes).create }.to raise_exception(Virtus::CoercionError)
    end

    context "invalid error is dupicate" do
      it "raises a DuplicateError", vcr: { record: :none, cassette_name: "orders/create#duplicate" } do
        @attributes[:external_id] = 1234
        expect { Fosdick::Order.new(@attributes).create }.to raise_exception(Fosdick::DuplicateError)
      end
    end
  end

  context 'given a fosdick response with no error message body' do
    it 'throws an instance of UnspecifiedError', vcr: {
      record: :none,
      cassette_name: 'orders/create#empty_error_string'
    } do
      @attributes[:external_id] = 1233
      expect { Fosdick::Order.new(@attributes).create }.to raise_exception(Fosdick::UnspecifiedError)
    end
  end
end
