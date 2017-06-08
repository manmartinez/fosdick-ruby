module Fosdick
  class Receipt
    include Virtus.model

    attribute :date_time, DateTime
    attribute :warehouse, String
    attribute :receiver_num, Integer
    attribute :container_num, String
    attribute :po_num, String
    attribute :carrier_name, String
    attribute :sku, String
    attribute :description_product, String
    attribute :qty, Integer
    attribute :num_of_floor_loaded, Integer
    attribute :num_of_skids, Integer
    attribute :num_of_cartons, Integer
    attribute :updated_at, DateTime

    def self.all(options = {})
      Fosdick::Resource.new(self, "receipts").all(options)
    end
  end
end
