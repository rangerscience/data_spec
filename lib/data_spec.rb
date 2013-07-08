require "data_spec/version"
require 'data_spec/helpers'
require 'data_spec/matchers'

if RSpec && RSpec.respond_to?(:configure)
  RSpec.configure do |config|
    config.include DataSpec::Matchers
  end
end
