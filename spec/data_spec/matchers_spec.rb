require 'spec_helper'

describe DataSpec::Matchers do

  it "should match empty hashes" do
    {}.should match_data({})
    {}.should_not match_data([])
  end

  it "should match empty arrays" do
    [].should match_data([])
    [].should_not match_data({})
  end

  it "should match strings" do
    "Bacon".should match_data("Bacon")
    "Bacon".should_not match_data("Chunky")
  end

  it "should match integers" do
    1.should match_data(1)
    2.should_not match_data(1)
  end

  it "should match floats" do
    1.1.should match_data(1.1)
    2.1.should_not match_data(1.1)
  end

  it "should match true" do
    true.should match_data(true)
    true.should_not match_data(false)
  end

  it "should match false" do
    false.should match_data(false)
    false.should_not match_data(true)
  end

  it "should match nil" do
    nil.should match_data(nil)
    nil.should_not match_data("something")
  end

  it "should match hashes" do
    {1 => 2}.should match_data({1 => 2})
    {1 => 2, 3 => 4, 5 => 6}.should match_data({1 => 2, 3 => 4, 5 => 6})
    {1 => 2, 5 => 6, 3 => 4}.should match_data({1 => 2, 3 => 4, 5 => 6})

    {1 => 2}.should_not match_data({1 => 3})
    {1 => 2}.should_not match_data({2 => 2})
  end

  it "should match arrays" do
    [1,2,3].should match_data([1,2,3])

    [1,2,3].should_not match_data([2,1,3])
    [1,2,3].should_not match_data([2,2,3])
    [1,2,3].should_not match_data([1,2])
    [1,2,3].should_not match_data([1,2,3,4])
  end

  it "should match hash nesting" do
    { nested: { hash: { chunky: :bacon, bacon: :chunky }, one: :two }, three: :four }.should     match_data( { three: :four, nested: { one: :two, hash: { bacon: :chunky, chunky: :bacon } } })

    { nested: { hash: { chunky: :bacon, bacon: :chunky }, one: :two }, three: :four }.should_not match_data( { four:  :four, nested: { one: :two, hash: { bacon: :chunky, chunky: :bacon } } } )
    { nested: { hash: { chunky: :bacon, bacon: :chunky }, one: :two }, three: :four }.should_not match_data( { three: :five, nested: { one: :two, hash: { bacon: :chunky, chunky: :bacon } } } )
    { nested: { hash: { chunky: :bacon, bacon: :chunky }, one: :two }, three: :four }.should_not match_data( { three: :five, nested: { two: :two, hash: { bacon: :chunky, chunky: :bacon } } } )
    { nested: { hash: { chunky: :bacon, bacon: :chunky }, one: :two }, three: :four }.should_not match_data( { three: :five, nested: { one: :one, hash: { bacon: :chunky, chunky: :bacon } } } )
    { nested: { hash: { chunky: :bacon, bacon: :chunky }, one: :two }, three: :four }.should_not match_data( { three: :five, nested: { one: :two, hash: { nocab: :chunky, chunky: :bacon } } } )
    { nested: { hash: { chunky: :bacon, bacon: :chunky }, one: :two }, three: :four }.should_not match_data( { three: :five, nested: { one: :two, hash: { bacon: :yknuhc, chunky: :bacon } } } )
    
    { nested: { hash: { chunky: :bacon, bacon: :chunky }, one: :two }, three: :four }.should_not match_data( {               nested: { one: :two, hash: { bacon: :chunky, chunky: :bacon } } })
    { nested: { hash: { chunky: :bacon, bacon: :chunky }, one: :two }, three: :four }.should_not match_data( { three: :four, nested: {            hash: { bacon: :chunky, chunky: :bacon } } })
    { nested: { hash: { chunky: :bacon, bacon: :chunky }, one: :two }, three: :four }.should_not match_data( { three: :four, nested: { one: :two, hash: {                 chunky: :bacon } } })
  end

  it "should match array nesting" do
    [1, [2, [3, 4], 5], 6].should     match_data([1, [2, [3, 4], 5], 6])

    [1, [2, [3, 4], 5], 6].should_not match_data([2, [2, [3, 4], 5], 6])
    [1, [2, [3, 4], 5], 6].should_not match_data([1, [3, [3, 4], 5], 6])
    [1, [2, [3, 4], 5], 6].should_not match_data([1, [2, [4, 4], 5], 6])
    [1, [2, [3, 4], 5], 6].should_not match_data([1, [2, [3, 5], 6], 6])
    [1, [2, [3, 4], 5], 6].should_not match_data([1, [2, [3, 4], 5], 7])
    
    [1, [2, [3, 4], 5], 6].should_not match_data([   [2, [3, 4], 5], 6])
    [1, [2, [3, 4], 5], 6].should_not match_data([1, [   [3, 4], 5], 6])
    [1, [2, [3, 4], 5], 6].should_not match_data([1, [2, [   4], 5], 6])
    [1, [2, [3, 4], 5], 6].should_not match_data([1, [2, [3   ], 5], 6])
    [1, [2, [3, 4], 5], 6].should_not match_data([1, [2, [3, 4]   ], 6])
    [1, [2, [3, 4], 5], 6].should_not match_data([1, [2, [3, 4], 5]   ])
  end

  it "should match mixed nesting" do
    [1, {array: [2, {chunky: :bacon} ] } ].should     match_data([1, {array: [2, {chunky: :bacon} ] } ])

    [1, {array: [2, {chunky: :bacon} ] } ].should_not match_data([2, {array: [2, {chunky: :bacon} ] } ])
    [1, {array: [2, {chunky: :bacon} ] } ].should_not match_data([1, {yarra: [2, {chunky: :bacon} ] } ])
    [1, {array: [2, {chunky: :bacon} ] } ].should_not match_data([1, {array: [3, {chunky: :bacon} ] } ])
    [1, {array: [2, {chunky: :bacon} ] } ].should_not match_data([1, {array: [2, {yknuhc: :bacon} ] } ])
    [1, {array: [2, {chunky: :bacon} ] } ].should_not match_data([1, {array: [2, {chunky: :nocab} ] } ])
    
    [1, {array: [2, {chunky: :bacon} ] } ].should_not match_data([   {array: [2, {chunky: :bacon} ] } ])
    [1, {array: [2, {chunky: :bacon} ] } ].should_not match_data([1, {array: [   {chunky: :bacon} ] } ])
  end

  it "should match at a path" do
    [1, {array: [2, {chunky: :bacon} ] } ].should match_data({chunky: :bacon}).at('1/array/1')

    [1, {array: [2, {chunky: :bacon} ] } ].should_not match_data({bacon: :chunky}).at('1/array/1')
  end
end
