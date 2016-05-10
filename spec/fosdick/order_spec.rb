require "spec_helper"

describe Fosdick::Order do
  before do
    @attributes = {
      email: "test@test.net",
      client_code: "ad54LIADFJ2754",
      test: "Y",
      external_id: "2316",
      subtotal: 3.0,
      ad_code: "ECOMM",
      ship_firstname: "Bruce",
      ship_lastname: "Wayne",
      ship_address1: "12 Manor Drive",
      ship_city: "Gotham",
      ship_state: "NY",
      ship_zip: "11223",
      bill_firstname: "Lucius",
      bill_lastname: "Fox",
      bill_address1: "33 Wayne Ent Drive",
      bill_state: "NY",
      bill_zip: "11332",
      payment_type: 5,
      bill_city: "Gotham",
      items: [{ inv: 1, qty: 3, price_per: 1, num_of_payments: 1 }],
      total: 3.0
    }
  end

  context "build_payload" do
    it "should return the proper string format" do
      order = Fosdick::Order.new(@attributes)
      expect(order.build_payload).to include "ShipAddress1=12+Manor+Drive"
    end

    it "should properly set the line item data" do
      order = Fosdick::Order.new(@attributes)
      expect(order.build_payload).to include "Items=1"
      expect(order.build_payload).to include "Inv1=1"
      expect(order.build_payload).to include "Qty1=3"
    end
  end

  context "given a valid order" do
    it "POSTs the order to Fosdick", vcr: { record: :none, cassette_name: "orders/create#valid" } do
      result = Fosdick::Order.new(@attributes).create
      expect(result[:external_id]).to eq("2316")
    end

    it "returns a an order id from fosdick", vcr: { record: :none, cassette_name: "orders/create#valid" } do
      result = Fosdick::Order.new(@attributes).create
      expect(result[:order_id]).to_not be_nil
    end
  end

  context "given an invalid order" do
    it "does not post to fosdick", vcr: { record: :none, cassette_name: "orders/create#invalid" } do
      @attributes[:external_id] = 1233
      @attributes.delete(:ship_firstname)
      @attributes.delete(:ship_lastname)
      expect { Fosdick::Order.new(@attributes).create }.to raise_exception(Virtus::CoercionError)
    end

    # it "POSTs the order to Fosdick and fails", vcr: { record: :none, cassette_name: "orders/create#invalid" } do
    #   @attributes[:external_id] = 1233
    #   @attributes[:ship_firstname] = ""
    #   @attributes[:ship_lastname] = ""
    #   expect { Fosdick::Order.new(@attributes).create }.to raise_exception(Fosdick::InvalidError)
    # end
  end
end
