class Woods::Item < ActiveRecord::Base
  belongs_to :itemset
  belongs_to :player
end
