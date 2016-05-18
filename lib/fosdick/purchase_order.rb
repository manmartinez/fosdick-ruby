module Fosdick
  class PurchaseOrder
    require 'date'
    include Virtus.model

    attribute :po_num, String
    attribute :line_num, Integer
    attribute :item, String
    attribute :description, String
    attribute :class_code, String
    attribute :qty, Integer
    attribute :warehouse, String
    attribute :expected_delivery, Date
    attribute :po_date, Date
    attribute :vendor, String
    attribute :shipper, String
    attribute :upc, String
    attribute :cogs, Integer
    attribute :country_of_origin, String
    attribute :weight, Integer
    attribute :width, Integer
    attribute :height, Integer
    attribute :length, Integer
    attribute :custom1, String
    attribute :custom2, String
    attribute :custom3, String

    def create
      connection.post do |req|
        req.url  "/fosdickapi/purchaseorder.json"
        req.headers['Content-Type'] = 'application/json'
        req.body = attributes.to_json
      end
    end

    private

    def connection
      @connection ||= Fosdick.connection
    end
  end
end
