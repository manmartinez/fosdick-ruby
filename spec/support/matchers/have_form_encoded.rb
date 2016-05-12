RSpec::Matchers.define :have_form_encoded do |expected|
  match do |actual|
    expected.each do |key, value|
      encoded_param = URI.encode_www_form(key => value)
      expect(actual).to include(encoded_param)
    end
  end
end
