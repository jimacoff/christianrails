class Woods::Story < ApplicationRecord
  has_many :storytrees, dependent: :destroy
  has_many :finds

  has_many :itemsets,     dependent: :destroy
  has_many :items,        through: :itemsets
  has_many :palettes,     dependent: :destroy
  has_many :scorecards

  belongs_to :entry_tree, class_name: "Woods::Storytree", optional: true

  belongs_to :player

  validates_presence_of :name, :player

  # collect all nodes of all storytrees
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

  def left_count
    Woods::Scorecard.where(story_id: id).map{ |sc| sc.lefts }.reduce(:+) || 0
  end

  def right_count
    Woods::Scorecard.where(story_id: id).map{ |sc| sc.rights }.reduce(:+) || 0
  end

end
