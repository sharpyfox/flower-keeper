require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the FlowersHelper. For example:
#
# describe FlowersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe FlowersHelper do
  	it "50% must be blue" do
  		assert_equal "#0000FF", humidityToColor(50)
  	end

  	it "100% must be green" do
  		assert_equal "#00FF00", humidityToColor(100)
  	end

  	it "0% must be red" do
  		assert_equal "#FF0000", humidityToColor(0)
  	end

  	it "25% must be some color" do
  		assert_equal "#800080", humidityToColor(25)
  		assert_equal "#008080", humidityToColor(75)
  	end
end
