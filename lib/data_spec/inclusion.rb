require 'data_spec/helpers'

using DataSpec::Refinements
module DataSpec
  module Inclusion
    extend RSpec::Matchers::DSL

    matcher :include_data do |expected|
      match do |actual|
        DataSpec::Helpers.at_path(actual, @path).deep_include? expected
      end

      chain :at do |path|
        @path = path
      end

      diffable
    end

  end
end

RSpec.configure do |config|
  config.include DataSpec::Inclusion
end
