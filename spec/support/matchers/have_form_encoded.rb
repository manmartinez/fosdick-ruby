RSpec::Matchers.define :have_form_encoded do |expected|
  match do |actual|
    actual_params = Hash[URI.decode_www_form(actual)]

    expected.each do |key, value|
      expect(actual_params).to include(key => value.to_s)
    end
  end
end
