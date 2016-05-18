require "spec_helper"

describe Fosdick::PurchaseOrder do
  before do
    @attributes = {
      po_num: "100002",
      line_num: 1,
      item: "1006A-301-B",
      description: "pocket tee",
      class_code: "RI",
      qty: 41,
      warehouse: "CT",
      expected_delivery: "2016-06-15",
      custom1: "BOYS", # DIVISION/GENDER
      custom2: "PACIFIC", # COLOR
      custom3: "2/3", # SIZE
    }
  end

  context "given a valid purchase_order" do
    it "POSTs the purchase order to Fosdick", vcr: { record: :none, cassette_name: "purchase_orders/create#valid" } do
      result = Fosdick::PurchaseOrder.new(@attributes).create
      expect(JSON.parse(result.body)).to match({"success"=>"Purchase Order Received"})
    end
  end

  context "given an invalid purchase_order" do
    it "POSTs the purchase order to Fosdick", vcr: { record: :none, cassette_name: "purchase_orders/create#invalid" } do
      @attributes.delete(:qty)
      result = Fosdick::PurchaseOrder.new(@attributes).create
      expect(JSON.parse(result.body)).to match({"error"=>"qty must be provided"})
    end
  end
end