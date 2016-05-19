require "spec_helper"

describe Fosdick::Order do
  before do
    @attributes = {
      email: "test@test.net",
      external_id: "5584",
      subtotal: 7.0,
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
      bill_city: "Gotham",
      bill_state: "NY",
      bill_zip: "11332",
      payment_type: 5,
      items: [
        { inv: "sku-1", qty: 3, price_per: 1, num_of_payments: 1 },
        { inv: "sku-3", qty: 2, price_per: 2, num_of_payments: 1 }
      ],
      total: 7.0
    }
  end

  context "build_payload" do
    before do
      order = Fosdick::Order.new(@attributes)
      @payload = order.build_payload
    end

    it "has all the basic fields form-encoded" do
      expect(@payload).to have_form_encoded(
        "Email" => "test@test.net",
        "ExternalId" => "5584",
        "Subtotal" => 7.0,
        "Total" => 7.0,
        "AdCode" => "ECOMM",
        "ShipFirstname" => "Bruce",
        "ShipLastname" => "Wayne",
        "ShipAddress1" => "12 Manor Drive",
        "ShipCity" => "Gotham",
        "ShipState" => "NY",
        "ShipZip" => "11223",
        "BillFirstname" => "Lucius",
        "BillLastname" => "Fox",
        "BillAddress1" => "33 Wayne Ent Drive",
        "BillCity" => "Gotham",
        "BillState" => "NY",
        "BillZip" => "11332",
        "PaymentType" => 5,
      )
    end

    it "includes form-encoded default client code and test flag" do
      expect(@payload).to have_form_encoded(
        "ClientCode" => Fosdick.configuration.client_code,
        "Test" => "Y"
      )
    end

    it "has line items form-encoded" do
      order = Fosdick::Order.new(@attributes)
      expect(@payload).to have_form_encoded(
        "Items" => 2,
        "Inv1" => "sku-1",
        "Qty1" => 3,
        "Inv2" => "sku-3",
        "Qty2" => 2,
      )
    end
  end

  context "given a valid order" do
    it "POSTs the order to Fosdick", vcr: { record: :none, cassette_name: "orders/create#valid" } do
      result = Fosdick::Order.new(@attributes).create
      expect(result[:external_id]).to eq("5584")
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
  end
end
