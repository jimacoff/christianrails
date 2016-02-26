class Woods::Story < ActiveRecord::Base
  has_many :storytrees, dependent: :destroy

  has_many :finds

  belongs_to :player

  validates_presence_of :name, :player#, :entry_tree TODO get this in there

  def nodes
    nodes = []
    self.storytrees.each do |tree|
      nodes += tree.nodes
    end
    nodes
  end

end
