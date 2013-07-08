require 'spec_helper'

describe DataSpec::Matchers do

  it "can check array inclusion" do
    [1,2,3].should include_data([2])
    [1,2,3].should include_data([2,3])

    [1,2,3].should_not include_data([3,4])
  end

  it "can check nested array inclusion" do
    [1,[2,3],[4,5],6].should include_data([[2,3]])
    [1,[2,3],[4,5],6].should include_data([[2,3],[4,5]])


    [1,[2,3],[4,5],6].should_not include_data([2,3])
    [1,[2,3],[4,5],6].should_not include_data([[3,3],[4,5]])
    [1,[2,3],[4,5],6].should_not include_data([[2,3],[5,5]])
    [1,[2,3],[4,5],6].should_not include_data([3,4])
  end

  it "can check hash inclusion" do
    {one: :two, three: :four}.should include_data({three: :four})

    {one: :two, three: :four}.should_not include_data({four: :four})
  end

  it "can check nested hash inclusion" do
    {one: :two, three: {four: :five, seven: :eight}}.should include_data({three: {four: :five}})

    {one: :two, three: {four: :five, seven: :eight}}.should_not include_data({four: :five})
    {one: :two, three: {four: :five, seven: :eight}}.should_not include_data({three: {nine: :five}})
    {one: :two, three: {four: :five, seven: :eight}}.should_not include_data({three: {four: :ten}})
    {one: :two, three: {four: :five, seven: :eight}}.should_not include_data({nine: :ten})
  end

  it "can check mixed nested inclusion" do
    [1, {one: :two}].should include_data([{one: :two}])

    [1, {one: :two}].should_not include_data([{two: :two}])

    {one: :two, three: [1,2]}.should include_data({three: [1,2]})

    {one: :two, three: [1,2]}.should_not include_data({three: [2,2]})
  end

  it "can check at a path" do
    [1, {array: [2, {chunky: :bacon, bacon: :chunky} ] } ].should include_data({chunky: :bacon}).at("1/array/1")
    [1, {array: [2, {chunky: :bacon, bacon: :chunky} ] } ].should include_data({chunky: :bacon}).at("1/array/1")

    [1, {array: [2, {chunky: :bacon, bacon: :chunky} ] } ].should_not include_data({chunky: :nocab}).at("1/array/1")
  end
end
