module Fosdick
  class ShipmentDetail
    include Virtus.model

    attribute :fosdick_order_num, String
    attribute :fosdick_line_num, Integer
    attribute :sku, String
    attribute :quantity, Integer
    attribute :external_order_num, String
    attribute :external_line_num, Integer
    attribute :ship_date, Date
    attribute :trackings, Array[Fosdick::Tracking]

    def self.all(options = {})
      Fosdick::Resource.new(self, "shipmentdetail").all(options)
    end
  end
end
