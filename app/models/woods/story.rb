class Woods::Story < ActiveRecord::Base
  has_many :storytrees, dependent: :destroy
  has_many :nodes, through: :storytrees

  has_many :boxes, through: :nodes
  has_many :treelinks, through: :nodes
  has_many :possibleitems, through: :nodes
  has_many :paintballs, through: :nodes
  has_many :moverules, through: :nodes

  has_many :finds

end
