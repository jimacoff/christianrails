class Product < ActiveRecord::Base
  has_many :releases, inverse_of: :product
  has_and_belongs_to_many :price_combos

  validates_presence_of :title, :author, :price
end
