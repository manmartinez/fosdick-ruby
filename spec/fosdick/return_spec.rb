require "spec_helper"

describe Fosdick::Return do
  describe ".all", :vcr do
    context "given updated_at_min" do
      it "gets returns updated since the timestamp", :vcr do
        data = Fosdick::Return.all(updated_at_min: "2015-02-24T12:17:09-05:00")

        expect(data.map(&:class).uniq).to eq [Fosdick::Return]
        expect(data.map(&:attributes)).to eq [
          {:fosdick_order_num=>nil, :external_order_num=>nil, :sku=>"20PACC002", :line_item=>nil, :external_line_item=>nil, :return_date=>nil, :quantity_returned=>nil, :quality=>nil, :reason_code=>nil, :reason_description=>nil, :action_requested=>nil, :updated_at=>DateTime.parse("2015-02-24T12:17:29.477-05:00")},
          {:fosdick_order_num=>nil, :external_order_num=>nil, :sku=>"20PACC001", :line_item=>nil, :external_line_item=>nil, :return_date=>nil, :quantity_returned=>nil, :quality=>nil, :reason_code=>nil, :reason_description=>nil, :action_requested=>nil, :updated_at=>DateTime.parse("2015-02-24T12:17:09.613-05:00")}
        ]
      end
    end

    context "given returned_at_min" do
      it "get returns returned since the timestamp", :vcr do
        data = Fosdick::Return.all(returned_at_min: "2015-02-24T12:17:09-05:00", per_page: 1, page: 2)

        expect(data.map(&:class).uniq).to eq [Fosdick::Return]
        expect(data.size).to eq 1

        expect(data[0].attributes).to eq({
          :fosdick_order_num=>nil,
          :external_order_num=>nil,
          :sku=>"20PAC1502",
          :line_item=>nil,
          :external_line_item=>nil,
          :return_date=>nil,
          :quantity_returned=>nil,
          :quality=>nil,
          :reason_code=>nil,
          :reason_description=>nil,
          :action_requested=>nil,
          :updated_at=>DateTime.parse("2015-02-24T12:16:45.083-05:00")
        })
      end
    end
  end

  describe "ReasonCodes" do
    it "defines constants for valid reason codes" do
      expect(Fosdick::Return::ReasonCodes::ALL).to eq %w{01 02 03 04 05 06 07 08 09}
      expect(Fosdick::Return::ReasonCodes::UNDELIVERABLE).to eq '01'
      expect(Fosdick::Return::ReasonCodes::DEFECTIVE).to eq '02'
      expect(Fosdick::Return::ReasonCodes::WRONG_ITEM).to eq '03'
      expect(Fosdick::Return::ReasonCodes::NO_LONGER_WANTED).to eq '04'
      expect(Fosdick::Return::ReasonCodes::NEVER_ORDERED).to eq '05'
      expect(Fosdick::Return::ReasonCodes::REFUSED).to eq '06'
      expect(Fosdick::Return::ReasonCodes::NO_REASON_GIVEN).to eq '07'
      expect(Fosdick::Return::ReasonCodes::WRONG_SIZE_OR_COLOR).to eq '08'
      expect(Fosdick::Return::ReasonCodes::OTHER).to eq '09'
    end
  end
end
