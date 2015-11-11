class PriceCombo < ActiveRecord::Base
  has_and_belongs_to_many :products, inverse_of: :price_combos

  validates_presence_of :name, :price
  validates_numericality_of :price
end
