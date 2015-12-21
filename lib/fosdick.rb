require "fosdick/version"
require "fosdick/configuration"
require "fosdick/errors"
require "fosdick/inventory"
require "fosdick/return"

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

  def self.get(resource, options = {})
    headers = {}
    params = options

    resource += ".json" unless resource =~ /\.json$/

    response = connection.get(resource, params, headers)

    if response.success?
      JSON.parse(response.body)
    else
      handle_error(response)
    end
  end

  private

  def self.handle_error(response)
    message = error_message(response)

    case response.status
    when 401
      raise AuthenticationError, message
    when 404
      raise NotFoundError, message
    else
      if message == "Call limit exceeded"
        raise ThrottleError, message
      else
        raise ApiError, message
      end
    end
  end

  def self.error_message(response)
    begin
      body = JSON.parse(response.body)
      body["error"] || response.body
    rescue JSON::ParserError
      response.body
    end
  end
end
