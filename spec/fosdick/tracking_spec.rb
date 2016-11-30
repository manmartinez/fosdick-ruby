require 'spec_helper'

describe Fosdick::Tracking do
  describe '#tracking_num=' do
    it "strips whitespace from the tracking number" do
      tracking = described_class.new

      tracking.tracking_num = "\tTRACKING\t"

      expect(tracking.tracking_num).to eq("TRACKING")
    end

    it "handles nil values" do
      tracking = described_class.new

      tracking.tracking_num = nil

      expect(tracking.tracking_num).to eq(nil)
    end
  end
end
