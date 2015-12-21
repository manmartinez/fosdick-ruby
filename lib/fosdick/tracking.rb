module Fosdick
  class Tracking
    include Virtus.model

    attribute :tracking_num, String
    attribute :carrier_code, String
    attribute :carrier_name, String
  end
end
