module Fosdick
  # base class for all Fosdick API errors
  class ApiError < StandardError; end

  class AuthenticationError < ApiError; end
  class NotFoundError < ApiError; end
  class ThrottleError < ApiError; end
  class InvalidError < ApiError; end
  class FailureError < ApiError; end
  class UnspecifiedError < ApiError; end
end
