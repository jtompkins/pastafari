# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pastafari/version'

Gem::Specification.new do |spec|
  spec.name          = "pastafari"
  spec.version       = Pastafari::VERSION
  spec.authors       = ["Joshua Tompkins"]
  spec.email         = ["josh@joshtompkins.com"]

  spec.summary       = "A library for creating simple finite state machines."
  spec.homepage      = "https://github.com/jtompkins/pastafari"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency 'simplecov'
end
