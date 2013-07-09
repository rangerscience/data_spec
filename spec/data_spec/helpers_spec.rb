require 'spec_helper'

describe DataSpec do
  it "can remember things for use in evaluation" do
    time = Time.now
   DataSpec::Helpers.remember("@var", time)
   DataSpec::Helpers.evaluate("@var.day").should be(time.day)
  end
end
