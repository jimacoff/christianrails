class Store::StagedPurchase < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates_presence_of :user, :product

  TYPE_DIGITAL_SINGLE     = 0
  TYPE_DIGITAL_GIFT_PACK  = 1
  TYPE_PHYSICAL_SINGLE    = 2

  def self.gross_cart_value_for(user_id)
    total = 0
    Store::StagedPurchase.includes(:product).where(user_id: user_id).each do |sp|
      total += sp.product.price
    end
    total
  end

  def single?
    type_id == TYPE_DIGITAL_SINGLE
  end

  def gift_pack?
    type_id == TYPE_DIGITAL_GIFT_PACK
  end

end
