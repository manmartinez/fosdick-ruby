require 'spec_helper'

RSpec.describe Fosdick::Receipt do
  describe '.all', :vcr do
    context "when updated_at_min is given" do
      it "only returns receipts updated after the given date" do
        start_date = DateTime.parse("2017-05-01T00:00:00Z")
        receipts = Fosdick::Receipt.all(updated_at_min: start_date, per_page: 3)

        expect(receipts.map(&:class).uniq).to eq [Fosdick::Receipt]
        receipts.each do |receipt|
          expect(receipt.updated_at).to be > start_date
        end
      end
    end
  end
end
