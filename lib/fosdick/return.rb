module Fosdick
  class Return
    include Virtus.model

    attribute :fosdick_order_num, String
    attribute :external_order_num, String
    attribute :sku, String
    attribute :line_item, Integer
    attribute :external_line_item, String
    attribute :return_date, Date
    attribute :quantity_returned, Integer
    attribute :quality, Integer
    attribute :reason_code, String
    attribute :reason_description, String
    attribute :action_requested, String
    attribute :updated_at, DateTime

    def self.all(options = {})
      data = Fosdick.get("inventory", options)
      data.map { |attributes| new(attributes) }
    end
  end
end
