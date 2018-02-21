class Store::Order < ApplicationRecord
  has_many   :digital_purchases,   inverse_of: :order, dependent: :destroy
  has_many   :physical_purchases,  inverse_of: :order, dependent: :destroy

  belongs_to :price_combo,         inverse_of: :orders
  belongs_to :user,                inverse_of: :orders

  validates_presence_of :payer_id, :payment_id, :total_cents

  monetize :total_cents, :tax_cents, :discount_cents, :shipping_cost_cents
end
