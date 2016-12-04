class Woods::Box < ApplicationRecord
  belongs_to :node
  belongs_to :itemset, inverse_of: :boxes

  validates_presence_of :itemset, :node
end
