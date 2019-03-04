require "spec_helper"

describe Fosdick::Configuration do
  describe ".configure" do
    before do
      Fosdick.configure do |config|
        config.client_code = "abc123"
        config.client_name = "test"
        config.username = "username1"
        config.password = "password1"
      end
    end

    it "defaults to test mode" do
      expect(Fosdick.configuration.test_mode?).to be true
    end

    it "has a client code" do
      expect(Fosdick.configuration.client_code).to eq "abc123"
    end

    it "has a client name" do
      expect(Fosdick.configuration.client_name).to eq "test"
    end

    it "has a username and password" do
      expect(Fosdick.configuration.username).to eq "username1"
      expect(Fosdick.configuration.password).to eq "password1"
    end

    it "has a default host" do
      expect(Fosdick.configuration.host).to eq "https://cs.fosdickcorp.com/fosdickapi/"
    end
  end
end
