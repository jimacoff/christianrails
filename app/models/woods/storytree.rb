class Woods::Storytree < ApplicationRecord
  belongs_to :story
  has_many :nodes, dependent: :destroy

  has_many :boxes, through: :nodes
  has_many :paintballs, through: :nodes
  has_many :possibleitems, through: :nodes

  has_many :treelinks, foreign_key: "linked_tree_id"

  has_many :footprints

  validates_presence_of :name, :max_level, :story

  def get_first_node
    Woods::Node.includes(:paintball, :treelink, :possibleitem, :box).where(storytree_id: self.id, tree_index: 1).first
  end

end
