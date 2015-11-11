class Product < ActiveRecord::Base
  has_many :releases, inverse_of: :product
  has_many :purchases, inverse_of: :product
  has_many :users, through: :purchases
  has_and_belongs_to_many :price_combos, inverse_of: :products

  validates_presence_of :title, :author, :price
  validates_numericality_of :price
end
