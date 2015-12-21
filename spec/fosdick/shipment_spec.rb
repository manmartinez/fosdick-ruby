require "spec_helper"

describe Fosdick::Shipment do
  describe ".all", :vcr do
    context "given shipped_on_min" do
      it "gets shipments shipped since the timestamp", :vcr do
        data = Fosdick::Shipment.all(shipped_on_min: "2010-01-01T00:17:09-05:00", per_page: 3)

        expect(data.size).to eq 3
        expect(data.map(&:class).uniq).to eq [Fosdick::Shipment]
      end
    end

    context "given an external_order_num" do
      it "gets shipments for an order number", :vcr do
        data = Fosdick::Shipment.all(external_order_num: "9991012")

        expect(data.size).to eq 1
        expect(data.map(&:class).uniq).to eq [Fosdick::Shipment]

        expect(data[0].attributes).to include({
          :fosdick_order_num=>"99901201506460009",
          :external_order_num=>"9991012",
          :ship_date=>Date.parse("2015-02-06")
        })
      end

      it "includes tracking details" do
        data = Fosdick::Shipment.all(external_order_num: "9991012")

        expect(data[0][:trackings].size).to eq 1
        expect(data[0][:trackings][0]).to be_a Fosdick::Tracking

        expect(data[0][:trackings][0].attributes).to eq({
          :tracking_num=>"9274899998944526833273",
          :carrier_code=>"92",
          :carrier_name=>"FEDEX SMART POST"
        })
      end
    end
  end
end
