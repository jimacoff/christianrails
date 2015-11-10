class PriceCombo < ActiveRecord::Base
  has_many :combo_items, inverse_of: :price_combo

  validates_presence_of :name, :price

end
