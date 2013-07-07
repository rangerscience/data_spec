require 'spec_helper'

describe DataSpec::Block do
  it "can check versus a block" do
    "chunky".should match_block(lambda{|got| got.is_a? String})
    "chunky".should_not match_block(lambda{|got| got.is_a? Integer})
  end

  it "can check versus a block at a path" do
    [1, 'bacon'].should match_block(lambda{|got| got.is_a? String}).at("1")

    [1, 'bacon'].should_not match_block(lambda{|got| got.is_a? Integer}).at("1")
  end

end
