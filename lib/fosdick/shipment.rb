module Fosdick
  class Shipment
    include Virtus.model

    attribute :fosdick_order_num, String
    attribute :external_order_num, String
    attribute :ship_date, Date
    attribute :trackings, Array[Fosdick::Tracking]

    def self.all(options = {})
      data = Fosdick.get("shipments", options)
      data.map { |attributes| new(attributes) }
    end
  end
end