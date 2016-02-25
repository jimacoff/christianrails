class Woods::Find < ActiveRecord::Base
  belongs_to :player, inverse_of: :finds
  belongs_to :item
  belongs_to :story
end
