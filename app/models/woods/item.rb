class Woods::Item < ActiveRecord::Base
  belongs_to :itemset
  belongs_to :story

  has_many :item_downloads

  validates_presence_of :name, :value, :itemset

  def story
    self.itemset.story
  end

end
