class Woods::Possibleitem < ActiveRecord::Base
  belongs_to :node
  belongs_to :itemset

end
