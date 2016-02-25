class Woods::Box < ActiveRecord::Base
  belongs_to :node
  belongs_to :itemset, inverse_of: :boxes
end
