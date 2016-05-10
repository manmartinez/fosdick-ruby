require "virtus"

module Fosdick
  class Configuration
    include Virtus.model

    attribute :client_id, String
    attribute :client_name, String, default: "test"
    attribute :username, String
    attribute :password, String

    attribute :host, String, default: "https://www.customerstatus.com/fosdickapi/"
  end
end
