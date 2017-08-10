class Store::Order < ApplicationRecord
  has_many   :digital_purchases,   inverse_of: :order
  belongs_to :price_combo,         inverse_of: :orders
  belongs_to :user,                inverse_of: :orders

  validates_presence_of :payer_id, :payment_id, :total
end
