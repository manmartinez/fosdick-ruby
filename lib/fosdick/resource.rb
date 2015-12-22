module Fosdick
  class Resource
    attr_reader :resource_class
    attr_reader :endpoint

    def initialize(resource_class, endpoint)
      @resource_class = resource_class
      @endpoint = endpoint
    end

    def all(params = {})
      response = connection.get(endpoint_with_extension, params)

      if response.success?
        handle_success(response)
      else
        handle_error(response)
      end
    end

    private

    def connection
      @connection ||= Fosdick.connection
    end

    def endpoint_with_extension
      if endpoint =~ /\.json$/
        endpoint
      else
        "#{endpoint}.json"
      end
    end

    def handle_success(response)
      JSON.parse(response.body).map do |attributes|
        resource_class.new(attributes)
      end
    end

    def handle_error(response)
      message = error_message(response)

      case response.status
      when 401
        raise AuthenticationError, message
      when 404
        raise NotFoundError, message
      end

      if message =~ /limit exceeded/i
        raise ThrottleError, message
      else
        # ¯\_(ツ)_/¯
        raise ApiError, message
      end
    end

    def error_message(response)
      body = JSON.parse(response.body)
      body["error"] || response.body
    rescue JSON::ParserError
      response.body
    end
  end
end
