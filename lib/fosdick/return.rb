module Fosdick
  class Return
    include Virtus.model

    module ReasonCodes
      ALL = [
        UNDELIVERABLE       = '1'.freeze,
        DEFECTIVE           = '2'.freeze,
        WRONG_ITEM          = '3'.freeze,
        NO_LONGER_WANTED    = '4'.freeze,
        NEVER_ORDERED       = '5'.freeze,
        REFUSED             = '6'.freeze,
        NO_REASON_GIVEN     = '7'.freeze,
        WRONG_SIZE_OR_COLOR = '8'.freeze,
        OTHER               = '9'.freeze,
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
      Fosdick::Resource.new(self, "returns").all(options)
    end
  end
end
