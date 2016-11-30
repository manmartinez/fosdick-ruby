module Fosdick
  class Shipment
    include Virtus.model

    attribute :fosdick_order_num, String
    attribute :external_order_num, String
    attribute :ship_date, Date
    attribute :return_tracking, String
    attribute :trackings, Array[Fosdick::Tracking]

    def self.all(options = {})
      Fosdick::Resource.new(self, "shipments").all(options)
    end

    def return_tracking=(return_tracking)
      super return_tracking&.strip
    end
  end
end
