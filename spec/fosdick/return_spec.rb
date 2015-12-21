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
end
