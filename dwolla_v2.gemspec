# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dwolla_v2/version"

Gem::Specification.new do |spec|
  spec.name          = "dwolla_v2"
  spec.version       = DwollaV2::VERSION
  spec.authors       = ["Stephen Ausman"]
  spec.email         = ["stephen@dwolla.com"]

  spec.summary       = "Dwolla V2 Ruby client"
  spec.description   = "Dwolla V2 Ruby client"
  spec.homepage      = "https://github.com/Dwolla/dwolla-v2-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "webmock", "~> 3.6"

  spec.add_dependency "hashie", ">= 3.6"
  spec.add_dependency "faraday", ">= 0.15"
  spec.add_dependency "faraday_middleware", ">= 0.13"
end
