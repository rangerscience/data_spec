# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'data_spec/version'

Gem::Specification.new do |spec|
  spec.name          = "data_spec"
  spec.version       = DataSpec::VERSION
  spec.authors       = ["narfanator"]
  spec.email         = ["narafanator@gmail.com"]
  spec.description   = %q{RSpec & Cucumber for Data Examination}
  spec.summary       = %q{RSpec matchers and Cucumber steps for describing hash and array structures, including deep nesting}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_dependency "cucumber"
  spec.add_dependency "rspec"
end
