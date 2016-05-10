require "spec_helper"

describe Fosdick::Configuration do
  describe ".configure" do
    before do
      Fosdick.configure do |config|
        config.client_id = "abc123"
        config.client_name = "test"
        config.username = "username1"
        config.password = "password1"
      end
    end

    it "has a client id" do
      expect(Fosdick.configuration.client_id).to eq "abc123"
    end

    it "has a client name" do
      expect(Fosdick.configuration.client_name).to eq "test"
    end

    it "has a username and password" do
      expect(Fosdick.configuration.username).to eq "username1"
      expect(Fosdick.configuration.password).to eq "password1"
    end

    it "has a default host" do
      expect(Fosdick.configuration.host).to eq "https://www.customerstatus.com/fosdickapi/"
    end
  end
end
