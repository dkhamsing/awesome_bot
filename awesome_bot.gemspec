# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'awesome_bot/version'

Gem::Specification.new do |spec|
  spec.name          = AwesomeBot::PROJECT
  spec.version       = AwesomeBot::VERSION
  spec.authors       = ['Daniel Khamsing']
  spec.email         = ['dkhamsing8@gmail.com']

  spec.summary       = AwesomeBot::PROJECT_DESCRIPTION
  spec.description   = AwesomeBot::PROJECT_DESCRIPTION
  spec.homepage      = AwesomeBot::PROJECT_URL
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'faraday', '~> 0.9.2' # validate urls
  spec.add_runtime_dependency 'uri', '~> 4.4.29' # get urls
  spec.add_runtime_dependency 'parallel', '~> 1.6.1' # threading

  spec.add_development_dependency 'bundler', '~> 1.7' # travis version
end
