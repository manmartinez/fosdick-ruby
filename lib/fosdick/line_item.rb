module Fosdick
  class LineItem
    include Virtus.model(:nullify_blank => true)

    attribute :inv, String
    attribute :qty, Integer
    attribute :price_per, Money
    attribute :num_of_payments, Integer, default: 1
    attribute :line_custom, String, default: ""
  end
end
