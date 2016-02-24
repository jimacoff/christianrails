class Woods::Itemset < ActiveRecord::Base
  has_many :items, dependent: :destroy
  belongs_to :player
  has_many :boxes
end
