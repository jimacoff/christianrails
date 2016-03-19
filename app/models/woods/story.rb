class Woods::Story < ActiveRecord::Base
  has_many :storytrees, dependent: :destroy
  has_many :finds

  has_many :itemsets,     dependent: :destroy
  has_many :items,        through: :itemsets
  has_many :palettes,     dependent: :destroy

  belongs_to :player

  validates_presence_of :name, :player#, :entry_tree TODO get this in there

  def nodes
    nodes = []
    self.storytrees.each do |tree|
      nodes += tree.nodes
    end
    nodes
  end

  def pic_name
    name.downcase.gsub(' ','')
  end

end
