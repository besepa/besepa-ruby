# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'besepa/utils/version'

Gem::Specification.new do |spec|
  spec.name          = "besepa"
  spec.version       = Besepa::Utils::VERSION
  spec.authors       = ["besepa.com"]
  spec.email         = ["alberto@besepa.com"]
  spec.description   = %q{Ruby client for besepa.com}
  spec.summary       = %q{Ruby client for besepa.com}
  spec.homepage      = "http://www.besepa.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('faraday', '~> 0.9')
  spec.add_dependency('faraday_middleware', '~> 0.9')

  spec.add_development_dependency "bundler", "~> 1.3"

  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'webmock', '~> 1.20'
  spec.add_development_dependency "rake"
end
