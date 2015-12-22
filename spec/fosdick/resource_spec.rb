require "spec_helper"

describe Fosdick::Resource do
  describe "AuthenticationError", :vcr do
    it "is raised if username and password are invalid" do
      Fosdick.configuration.username = '///INVALID///'
      expect {
        Fosdick::Resource.new(Fosdick::Inventory, "inventory").all
      }.to raise_error(Fosdick::AuthenticationError, "Authentication failed")
    end
  end

  describe "ThrottleError", :vcr do
    it "is raised if too many requests are made too quickly" do
      expect {
        12.times { |i| Fosdick::Resource.new(Fosdick::Inventory, "inventory").all(per_page: 1) }
      }.to raise_error(Fosdick::ThrottleError, "Call limit exceeded")
    end
  end
end
