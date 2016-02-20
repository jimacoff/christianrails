class Purchase < ActiveRecord::Base
  belongs_to :product, inverse_of: :purchases
  belongs_to :order, inverse_of: :purchases
  belongs_to :user, inverse_of: :purchases

  validates_presence_of :product, :order, :price

  TAX_RATE = 0.15
end
