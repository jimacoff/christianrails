class Woods::Item < ActiveRecord::Base
  belongs_to :itemset
  belongs_to :player, through: :itemset  #TODO gotta migrate this around
end
