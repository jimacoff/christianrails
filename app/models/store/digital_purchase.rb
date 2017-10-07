class Store::DigitalPurchase < ApplicationRecord
  belongs_to :product, inverse_of: :digital_purchases
  belongs_to :order,   inverse_of: :digital_purchases
  belongs_to :user,    inverse_of: :digital_purchases

  validates_presence_of :product, :order, :price

  TYPE_DIGITAL_SINGLE     = 0
  TYPE_DIGITAL_GIFT_PACK  = 1

  TAX_RATE = 0.15
  GIFTPACK_SIZE = 5

  def single?
    type_id == TYPE_DIGITAL_SINGLE
  end

  def gift_pack?
    type_id == TYPE_DIGITAL_GIFT_PACK
  end

end
