module Fosdick
  class Return
    include Virtus.model

    module ReasonCodes
      ALL = [
        UNDELIVERABLE       = '01'.freeze,
        DEFECTIVE           = '02'.freeze,
        WRONG_ITEM          = '03'.freeze,
        NO_LONGER_WANTED    = '04'.freeze,
        NEVER_ORDERED       = '05'.freeze,
        REFUSED             = '06'.freeze,
        NO_REASON_GIVEN     = '07'.freeze,
        WRONG_SIZE_OR_COLOR = '08'.freeze,
        OTHER               = '09'.freeze,
      ].freeze
    end

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
