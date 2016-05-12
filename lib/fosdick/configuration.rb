require "virtus"

module Fosdick
  class Configuration
    include Virtus.model

    attribute :client_code, String
    attribute :client_name, String, default: "test"
    attribute :username, String
    attribute :password, String
    attribute :test_mode, Boolean, default: true

    attribute :host, String, default: "https://www.customerstatus.com/fosdickapi/"
  end
end
