class Store::DigitalPurchase < ApplicationRecord
  belongs_to :product, inverse_of: :digital_purchases
  belongs_to :order,   inverse_of: :digital_purchases
  belongs_to :user,    inverse_of: :digital_purchases

  validates_presence_of :product, :order, :price

  TAX_RATE = 0.15
end
