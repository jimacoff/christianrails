class Woods::Paintball < ActiveRecord::Base
  belongs_to :node
  belongs_to :palette

end
