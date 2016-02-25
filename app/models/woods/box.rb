class Woods::Box < ActiveRecord::Base
  belongs_to :node
  belongs_to :itemset

  belongs_to :storytree
  belongs_to :story

end
