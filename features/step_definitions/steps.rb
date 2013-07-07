Given(/^the data is:$/) do |yaml|
  @data = DataSpec.parse(yaml)
end

