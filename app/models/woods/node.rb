class Woods::Node < ActiveRecord::Base
  belongs_to :storytree
  belongs_to :moverule

  has_one :box,           dependent: :destroy
  has_one :paintball,     dependent: :destroy
  has_one :possibleitem,  dependent: :destroy
  has_one :treelink,      dependent: :destroy

  validates_presence_of :name, :storytree, :tree_index
end
