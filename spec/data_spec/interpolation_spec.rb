require 'spec_helper'

describe DataSpec::Helpers do

  it "parses YAML" do
    DataSpec.parse("[1, {array: [2, {chunky: bacon} ] } ]").should match_data([1, {'array' => [2, {'chunky' => 'bacon'} ] } ])
    yaml = 
      """
- 1
- array:
  - 2
  - chunky: bacon
      """
    DataSpec.parse(yaml).should match_data([1, {'array' => [2, {'chunky' => 'bacon'} ] } ])
  end

  it "parses JSON" do
    DataSpec.parse('[1, {"array": [2, {"chunky": "bacon"} ] } ]').should match_data([1, {'array' => [2, {'chunky' => 'bacon'} ] } ])

    json = <<-eot
[
  1, 
  {
    "array": [
      2, 
      { 
        "chunky": "bacon"
      }
    ]
  }
]
eot

    DataSpec.parse(json).should match_data([1, {'array' => [2, {'chunky' => 'bacon'} ] } ])
  end

  it "interpolates json" do
    json = <<-eot
[
  1, 
  {
    "array": [
      `1+1`, 
      { 
        "chunky": "bacon"
      }
    ]
  }
]
eot
    DataSpec.parse(json).should match_data([1, {'array' => [2, {'chunky' => 'bacon'} ] } ])
  end

  it "interpolates array values" do
    DataSpec.parse("[1, 2, `1+2`]").should match_data([1,2,3])

    DataSpec.parse("[1, 2, `1+2`]").should_not match_data([1,2,4])
  end

  it "interpolates hash values" do
    DataSpec.parse("{one: two, three: `2+2`}").should match_data({'one' => 'two', 'three' => 4})

    DataSpec.parse("{one: two, three: `2+2`}").should_not match_data({'one' => 'two', 'three' => 5})
  end

  it "interpolates nested values" do
    DataSpec.parse("[1, {array: [`1+1`, {chunky: `'bacon'.to_sym`} ] } ]").should match_data([1, {'array' => [2, {'chunky' => :bacon} ] } ])

    DataSpec.parse("[1, {array: [`1+1`, {chunky: `'bacon'.to_sym`} ] } ]").should_not match_data([1, {'array' => [3, {'chunky' => :bacon} ] } ])
    DataSpec.parse("[1, {array: [`1+1`, {chunky: `'bacon'.to_sym`} ] } ]").should_not match_data([1, {'array' => [2, {'chunky' => :nocab} ] } ])
  end
end
