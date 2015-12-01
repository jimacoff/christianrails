class Order < ActiveRecord::Base
  has_many :purchases, inverse_of: :order
  belongs_to :price_combo, inverse_of: :orders

  validates_presence_of :payer_id, :payment_id, :total

end