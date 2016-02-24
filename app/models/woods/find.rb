class Woods::Find < ActiveRecord::Base
  belongs_to :player
  belongs_to :item
  belongs_to :story
end
