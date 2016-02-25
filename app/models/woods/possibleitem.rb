class Woods::Possibleitem < ActiveRecord::Base
  belongs_to :node

  belongs_to :storytree
  belongs_to :story
end
