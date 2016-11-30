module Fosdick
  class Tracking
    include Virtus.model

    attribute :tracking_num, String
    attribute :carrier_code, String
    attribute :carrier_name, String

    def tracking_num=(tracking_num)
      super tracking_num.strip
    end
  end
end
