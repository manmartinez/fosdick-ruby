if ENV['FOSDICK_USERNAME'].nil? || ENV['FOSDICK_CLIENT_CODE'].nil?
  raise "Set up your .env file and use `foreman run rake`!"
end

RSpec.configure do |config|
  config.before do
    Fosdick.configure do |fosdick|
      fosdick.client_code = ENV['FOSDICK_CLIENT_CODE']
      fosdick.client_name = ENV['FOSDICK_CLIENT_NAME']
      fosdick.username = ENV['FOSDICK_USERNAME']
      fosdick.password = ENV['FOSDICK_PASSWORD']
    end
  end
end
