class Woods::Player < ActiveRecord::Base
  has_many :finds,        dependent: :destroy
  has_many :scorecards,   dependent: :destroy
  has_many :footprints,   through: :scorecards

  has_many :itemsets,     dependent: :destroy
  has_many :items,        through: :itemsets
  has_many :stories,     dependent: :destroy

  has_many :item_downloads,  dependent: :destroy

  has_many :palettes,     dependent: :destroy

  belongs_to :user

  validates_presence_of :user

  def username
    self.user.username
  end

  def has_item?(item_id_to_check)
    finds.collect{ |f| f.item_id }.include?(item_id_to_check)
  end

  def has_item_in_itemset?(itemset_id_to_check)
    finds.collect{ |f| f.item.itemset_id }.uniq.include?(itemset_id_to_check)
  end

  def total_score
    score = 0
    finds.each do |f|
      score += f.item.value
    end
    score
  end

  def owns_story?(story)
    story.player_id == id
  end

end
