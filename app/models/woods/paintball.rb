class Woods::Paintball < ApplicationRecord
  belongs_to :node
  belongs_to :palette

  validates_presence_of :node, :palette
end
