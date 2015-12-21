module Fosdick
  class Inventory
    include Virtus.model

    attribute :sku, String
    attribute :available, Boolean
    attribute :ct_quantity, Integer
    attribute :nv_quantity, Integer
    attribute :other_quantity, Integer
    attribute :committed, Integer
    attribute :available_quantity, Integer
    attribute :updated_at, DateTime

    def self.all(options = {})
      data = Fosdick.get("inventory", options)
      data.map { |attributes| new(attributes) }
    end
  end
end
