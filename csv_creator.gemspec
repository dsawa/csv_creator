# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csv_creator/version'

Gem::Specification.new do |spec|
  spec.name          = "csv_creator"
  spec.version       = CsvCreator::VERSION
  spec.authors       = ["Dorian Sawa"]
  spec.email         = ["dorian.sawa@gmail.com"]

  spec.summary       = %q{This gem can help you with generating CSV file from collections of objects.}
  spec.description   = %q{CsvCreator provides nice, configurable interface which will generate CSV file for you, from collection you want (database or array with non-db related objects).}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|.idea)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "~> 4.0", ">= 4.0"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.7"
  spec.add_development_dependency "pry", "~> 0.10.1"
end
