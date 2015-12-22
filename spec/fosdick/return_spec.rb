require "spec_helper"

describe Fosdick::Return do
  describe ".all", :vcr do
    context "given updated_at_min" do
      it "gets returns updated since the timestamp", :vcr do
        data = Fosdick::Return.all(updated_at_min: "2015-02-24T12:17:09-05:00", per_page: 3)

        expect(data.map(&:class).uniq).to eq [Fosdick::Return]
        expect(data.map(&:attributes)).to eq [
          {:fosdick_order_num=>"99904201435221005", :external_order_num=>"986918", :sku=>"92432", :line_item=>3, :external_line_item=>nil, :return_date=>Date.parse("2014-09-16"), :quantity_returned=>1, :quality=>0, :reason_code=>"4", :reason_description=>"No Longer Wanted", :action_requested=>"Refund", :updated_at=>DateTime.parse("2015-02-24T12:26:33.817-05:00")},
          {:fosdick_order_num=>"99904201435129010", :external_order_num=>"986700", :sku=>"91132", :line_item=>1, :external_line_item=>nil, :return_date=>Date.parse("2014-09-16"), :quantity_returned=>1, :quality=>2, :reason_code=>"4", :reason_description=>"No Longer Wanted", :action_requested=>"Refund", :updated_at=>DateTime.parse("2015-02-24T12:26:20.473-05:00")},
          {:fosdick_order_num=>"99904201435124087", :external_order_num=>"986602", :sku=>"91532", :line_item=>4, :external_line_item=>nil, :return_date=>Date.parse("2014-09-16"), :quantity_returned=>1, :quality=>2, :reason_code=>"4", :reason_description=>"No Longer Wanted", :action_requested=>"Refund", :updated_at=>DateTime.parse("2015-02-24T12:26:02.973-05:00")},
        ]
      end
    end

    context "given returned_at_min" do
      it "get returns returned since the timestamp", :vcr do
        data = Fosdick::Return.all(returned_on_min: "2014-01-01T12:17:09-05:00", per_page: 1, page: 2)

        expect(data.map(&:class).uniq).to eq [Fosdick::Return]
        expect(data.size).to eq 1

        expect(data[0].attributes).to eq({
          :fosdick_order_num=>"99904201435124087", :external_order_num=>"986602", :sku=>"91532", :line_item=>4, :external_line_item=>nil, :return_date=>Date.parse("2014-09-16"), :quantity_returned=>1, :quality=>2, :reason_code=>"4", :reason_description=>"No Longer Wanted", :action_requested=>"Refund", :updated_at=>DateTime.parse("2015-02-24T12:26:02.973-05:00")
        })
      end
    end
  end

  describe "ReasonCodes" do
    it "defines constants for valid reason codes" do
      expect(Fosdick::Return::ReasonCodes::ALL).to eq %w{1 2 3 4 5 6 7 8 9}
      expect(Fosdick::Return::ReasonCodes::UNDELIVERABLE).to eq '1'
      expect(Fosdick::Return::ReasonCodes::DEFECTIVE).to eq '2'
      expect(Fosdick::Return::ReasonCodes::WRONG_ITEM).to eq '3'
      expect(Fosdick::Return::ReasonCodes::NO_LONGER_WANTED).to eq '4'
      expect(Fosdick::Return::ReasonCodes::NEVER_ORDERED).to eq '5'
      expect(Fosdick::Return::ReasonCodes::REFUSED).to eq '6'
      expect(Fosdick::Return::ReasonCodes::NO_REASON_GIVEN).to eq '7'
      expect(Fosdick::Return::ReasonCodes::WRONG_SIZE_OR_COLOR).to eq '8'
      expect(Fosdick::Return::ReasonCodes::OTHER).to eq '9'
    end
  end
end
