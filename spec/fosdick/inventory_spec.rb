require "spec_helper"

describe Fosdick::Inventory do
  describe ".all", :vcr do
    context "given a page size and page number" do
      it "gets a paginated list of inventory levels for products" do
        data = Fosdick::Inventory.all(per_page: 3, page: 2)

        expect(data.map(&:class).uniq).to eq [Fosdick::Inventory]
        expect(data.map(&:attributes)).to eq [
          { :sku=>"001PRI", :available=>false, :ct_quantity=>0, :nv_quantity=>0, :other_quantity=>0, :committed=>0, :available_quantity=>0, :updated_at=>DateTime.parse("2015-02-24T12:15:13.423-05:00") },
          { :sku=>"001FEDEX", :available=>false, :ct_quantity=>0, :nv_quantity=>0, :other_quantity=>0, :committed=>0, :available_quantity=>0, :updated_at=>DateTime.parse("2015-02-24T12:14:46.313-05:00") },
          { :sku=>"#BOX3", :available=>true, :ct_quantity=>25, :nv_quantity=>0, :other_quantity=>0, :committed=>0, :available_quantity=>25, :updated_at=>DateTime.parse("2015-02-24T12:14:15.19-05:00") }
        ]
      end
    end

    context "given updated_at_min" do
      it "gets inventory levels updated since the timestamp" do
        data = Fosdick::Inventory.all(updated_at_min: "2015-02-24T12:17:09-05:00")

        expect(data.map(&:class).uniq).to eq [Fosdick::Inventory]
        expect(data.map(&:attributes)).to eq [
          { sku: "20PACC002", available: false, ct_quantity: 0, nv_quantity: 0, other_quantity: 0, committed: 0, available_quantity: 0, updated_at: DateTime.parse("2015-02-24T12:17:29.477-05:00") },
          { sku: "20PACC001", available: false, ct_quantity: 0, nv_quantity: 0, other_quantity: 0, committed: 1, available_quantity: -1, updated_at: DateTime.parse("2015-02-24T12:17:09.613-05:00") },
        ]
      end
    end
  end
end
