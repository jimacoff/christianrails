class Woods::Find < ApplicationRecord
  belongs_to :player, inverse_of: :finds
  belongs_to :item
  belongs_to :story

  validates_presence_of :player, :item, :story
end
