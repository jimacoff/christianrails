class Woods::Itemset < ActiveRecord::Base
  has_many :items, dependent: :destroy
  has_many :possibleitems, dependent: :destroy
  has_many :boxes

  belongs_to :player  #TODO come back to this

  validates_presence_of :name, :player

end
