require 'data_spec'

World(DataSpec::Helpers, DataSpec::Matchers)

# Then the data at "path" should be "data"
# Then the data should be: (...)
Then(/^the data(?: at "(.*?)")? should be:?(?: "(.*?)")?$/) do |path, inline, *block|
  data.should match_data(DataSpec.parse(inline || block.first)).at(path)
end

Then(/^the data(?: at "(.*?)")? should include:?(?: "(.*?)")?$/) do |path, inline, *block|
  data.should include_data(DataSpec.parse(inline || block.first)).at(path)
end

Then(/^the data at "(.*?)" should be of type ([A-Z][a-z]+)$/) do |path, type|
  data.should match_block(lambda{|item| item.is_a? Object.const_get(type)}).at(path)
end
