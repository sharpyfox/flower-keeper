class Flower < ActiveRecord::Base
  attr_accessible :cosmId, :name

  # Validation
  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :cosmId, :presence => true, :length => { :maximum => 20 }
end
