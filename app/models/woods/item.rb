class Woods::Item < ActiveRecord::Base
  belongs_to :itemset
  belongs_to :player

  has_many :item_downloads

  validates_presence_of :name, :value, :itemset

  def player
    self.itemset.player
  end

end
