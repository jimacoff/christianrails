class Woods::Storytree < ActiveRecord::Base
  belongs_to :story
  has_many :nodes

  has_many :boxes, through: :nodes
  has_many :treelinks, through: :nodes
  has_many :paintballs, through: :nodes
  has_many :boxes, through: :nodes
  has_many :boxes, through: :nodes

  has_many :footprints
end
