require 'spec_helper'

describe Flower do
  it "must have a name" do    
    subject.should have(1).error_on(:name)
  end

  it "must have a comId" do
    subject.should have(1).error_on(:cosmId)
  end
end
