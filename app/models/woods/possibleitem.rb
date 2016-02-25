class Woods::Possibleitem < ActiveRecord::Base
  belongs_to :node
  belongs_to :itemset

  validates_presence_of :itemset, :node
end
