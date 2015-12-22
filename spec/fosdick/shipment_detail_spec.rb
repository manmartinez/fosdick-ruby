require "spec_helper"

describe Fosdick::ShipmentDetail do
  describe ".all", :vcr do
    context "given shipped_on_min" do
      let(:data) { Fosdick::Shipment.all(shipped_on_min: "2010-02-24T12:17:09-05:00", per_page: 3) }

      it "returns an array of Fosdick::Shipments" do
        expect(data.map(&:class).uniq).to eq [Fosdick::Shipment]
      end

      it "gets details of shipments shipped since the timestamp", :vcr do
        expect(data.map(&:class).uniq).to eq [Fosdick::Shipment]
        expect(data.size).to eq 3
      end
    end

    context "given a fosdick_order_num", :vcr do
      let(:data) { Fosdick::Shipment.all(fosdick_order_num: "99901201506460009") }

      it "gets shipments for the given order" do
        expect(data.size).to eq 1

        expect(data[0].attributes).to include({
          :fosdick_order_num=>"99901201506460009",
          :external_order_num=>"9991012",
          :ship_date=>Date.parse("2015-02-06")
        })
      end

      it "includes tracking details for order" do
        expect(data[0][:trackings].size).to eq 1
        expect(data[0][:trackings][0]).to be_a Fosdick::Tracking

        expect(data[0][:trackings][0].attributes).to eq({
          :tracking_num=>"9274899998944526833273",
          :carrier_code=>"92",
          :carrier_name=>"FEDEX SMART POST"
        })
      end
    end

    context "given an external_order_num" do
      let(:data) { Fosdick::Shipment.all(external_order_num: "9991012") }

      it "gets shipments for the given order", :vcr do
        expect(data.size).to eq 1

        expect(data[0].attributes).to include({
          :fosdick_order_num=>"99901201506460009",
          :external_order_num=>"9991012",
          :ship_date=>Date.parse("2015-02-06")
        })
      end

      it "includes tracking details for order" do
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
