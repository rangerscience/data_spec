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

  module Block 
    extend RSpec::Matchers::DSL

    matcher :match_block do |block|
      match do |actual|
        block.call DataSpec::Helpers.at_path(actual, @path)
      end

      chain :at do |path|
        @path = path
      end
    end
  end

  module Interpolation
  end
end
