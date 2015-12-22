require 'spec_helper'

describe Fosdick do
  it 'has a version number' do
    expect(Fosdick::VERSION).not_to be nil
  end

  describe ".connection" do
    it "creates a Faraday connection" do
      conn = Fosdick.connection
      expect(conn).not_to be_nil
      expect(conn.url_prefix.to_s).to eq Fosdick.configuration.host
    end
  end
end
