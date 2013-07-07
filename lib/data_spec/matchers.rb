require 'data_spec/helpers'

using DataSpec::Refinements
module DataSpec
  module Matchers
    extend RSpec::Matchers::DSL

    matcher :match_data do |expected|
      match do |actual|
        DataSpec::Helpers.at_path(actual, @path) == expected
      end

      chain :at do |path|
        @path = path
      end

      diffable
    end

  end
end

RSpec.configure do |config|
  config.include DataSpec::Matchers
end
