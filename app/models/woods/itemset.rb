class Woods::Itemset < ActiveRecord::Base
  has_many :items, dependent: :destroy
  has_many :possibleitems, dependent: :destroy
  belongs_to :player  #TODO come back to this
  has_many :boxes
end
