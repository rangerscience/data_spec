require File.expand_path("../../data_spec", __FILE__)
require 'data_spec'
require 'time'

World(DataSpec::Helpers, DataSpec::Matchers)

Given(/^`(.*?)` is:?(?: "(.*?)")?$/) do |var, inline, *block|
  DataSpec::Helpers.evaluate("#{var} = DataSpec.parse(%##{(inline || block.first)}#)")
end

Given(/^`(.*?)` includes:?(?: "(.*?)")?$/) do |var, inline, *block|
  if DataSpec.parse("`#{var}`").is_a? Hash
    DataSpec::Helpers.evaluate("#{var}.merge! DataSpec.parse(%##{(inline || block.first)}#)")
  elsif DataSpec.parse("`#{var}`").is_a? Array
    DataSpec::Helpers.evaluate("#{var} += DataSpec.parse(%##{(inline || block.first)}#)")
  end
end

# Then the data at "path" should be "data"
# Then the data should be: (...)
Then(/^the data(?: at "(.*?)")? should be:?(?: "(.*?)")?$/) do |path, inline, *block|
  data.should match_data(DataSpec.parse(inline || block.first)).at(path)
end

Then(/^the data(?: at "(.*?)")? should include:?(?: "(.*?)")?$/) do |path, inline, *block|
  data.should include_data(DataSpec.parse(inline || block.first)).at(path)
end

Then(/^the data at "(.*?)" should be of type ([A-Z][a-z]+)$/) do |path, type|
  if type == "Time"
    #JSON doesn't actually interpret a time string into a Time,
    # YAML will, but Time doesn't parse a Time object
    data.should match_block(lambda{|item| Time.parse(item.to_s).is_a? Time}).at(path)
  else
    data.should match_block(lambda{|item| item.is_a? Object.const_get(type)}).at(path)
  end
end
