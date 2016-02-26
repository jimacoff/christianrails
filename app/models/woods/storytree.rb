class Woods::Storytree < ActiveRecord::Base
  belongs_to :story
  has_many :nodes, dependent: :destroy

  has_many :boxes, through: :nodes
  has_many :paintballs, through: :nodes
  has_many :possibleitems, through: :nodes

  has_many :treelinks, foreign_key: "linked_tree"

  has_many :footprints

  validates_presence_of :name, :max_level, :story

  def get_first_node
    Woods::Node.where(storytree_id: self.id, tree_index: 1).first
  end

end
