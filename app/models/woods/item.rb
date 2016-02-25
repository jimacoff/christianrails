class Woods::Item < ActiveRecord::Base
  belongs_to :itemset
  belongs_to :player

  def player
    self.itemset.player
  end

end
