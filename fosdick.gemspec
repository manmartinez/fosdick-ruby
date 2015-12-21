# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fosdick/version'

Gem::Specification.new do |spec|
  spec.name          = "fosdick"
  spec.version       = Fosdick::VERSION
  spec.authors       = ["Jeremy Weiskotten"]
  spec.email         = ["jeremy@teamlaunch.com"]

  spec.summary       = %q{Ruby wrapper for the Fosdick Fulfillment API.}
  spec.description   = %q{Ruby wrapper for the Fosdick Fulfillment API.}
  spec.homepage      = "http://www.teamlaunch.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.9.2"
  spec.add_dependency "patron", "~> 0.5.0"
  spec.add_dependency "virtus", "~> 1.0.5"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard-rspec", "~> 4.6.4"
  spec.add_development_dependency "vcr", "~> 3.0.1"
  spec.add_development_dependency "foreman"
end
