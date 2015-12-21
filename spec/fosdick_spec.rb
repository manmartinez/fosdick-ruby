require 'spec_helper'

describe Fosdick do
  it 'has a version number' do
    expect(Fosdick::VERSION).not_to be nil
  end

  describe "AuthenticationError", :vcr do
    it "is raised if username and password are invalid" do
      Fosdick.configuration.username = '///INVALID///'
      expect { Fosdick.get("inventory") }.to raise_error(Fosdick::AuthenticationError, "Authentication failed")
    end
  end

  describe "ThrottleError", :vcr do
    it "is raised if too many requests are made too quickly" do
      expect {
        12.times { |i| Fosdick.get("inventory", per_page: 1, page: 1) }
      }.to raise_error(Fosdick::ThrottleError, "Call limit exceeded")
    end
  end

  describe ".connection" do
    it "creates a Faraday connection" do
      conn = Fosdick.connection
      expect(conn).not_to be_nil
      expect(conn.url_prefix.to_s).to eq Fosdick.configuration.host
    end
  end
end
