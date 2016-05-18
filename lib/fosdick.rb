require "fosdick/version"
require "fosdick/configuration"
require "fosdick/errors"
require "fosdick/money"
require "fosdick/resource"
require "fosdick/inventory"
require "fosdick/line_item"
require "fosdick/order"
require "fosdick/purchase_order"
require "fosdick/return"
require "fosdick/tracking"
require "fosdick/shipment"
require "fosdick/shipment_detail"

require "faraday"
require "json"
require "patron"

module Fosdick
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.connection
    conn = ::Faraday.new(:url => configuration.host) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      # faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  :patron
    end

    unless configuration.username.nil?
      conn.basic_auth(configuration.username, configuration.password)
    end

    conn
  end
end
