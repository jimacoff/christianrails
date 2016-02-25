class Woods::Paintball < ActiveRecord::Base
  belongs_to :node
  belongs_to :palette

  belongs_to :storytree
  belongs_to :story
end
