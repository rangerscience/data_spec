require 'data_spec/helpers'
require 'diffy'

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

      failure_message_for_should do |actual|
        Diffy::Diff.new(
          DataSpec::Helpers.at_path(actual, @path).to_yaml,
          expected.to_yaml
        )
      end
    end

    matcher :include_data do |expected|
      match do |actual|
        DataSpec::Helpers.at_path(actual, @path).deep_include? expected
      end

      chain :at do |path|
        @path = path
      end

      failure_message_for_should do |actual|
        Diffy::Diff.new(
          DataSpec::Helpers.at_path(actual, @path).to_yaml,
          expected.to_yaml
        )
      end
    end

    matcher :match_block do |block|
      match do |actual|
        block.call DataSpec::Helpers.at_path(actual, @path)
      end

      chain :at do |path|
        @path = path
      end
    end
  end
end
