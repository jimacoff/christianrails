class Woods::Story < ActiveRecord::Base
  has_many :storytrees, dependent: :destroy

  has_many :finds

  belongs_to :player


  def nodes
    nodes = []
    self.storytrees.each do |tree|
      nodes += tree.nodes
    end
    nodes
  end

end
