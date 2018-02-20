class Store::StagedPurchase < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates_presence_of :user, :product

  TYPE_DIGITAL_SINGLE     = 0
  TYPE_DIGITAL_GIFT_PACK  = 1

  TYPE_PHYSICAL_SINGLE    = 2
  TYPE_PHYSICAL_5_PACK    = 3
  TYPE_PHYSICAL_BUNDLE    = 4

  def self.gross_cart_value_for(user_id)
    total = 0
    Store::StagedPurchase.includes(:product).where(user_id: user_id,
                                                   type_id: Store::StagedPurchase::TYPE_DIGITAL_SINGLE).each do |sp|
      total += sp.product.price_cents
    end

    Store::StagedPurchase.includes(:product).where(user_id: user_id,
                                                   type_id: Store::StagedPurchase::TYPE_DIGITAL_GIFT_PACK).each do |sp|
      total += sp.product.giftpack_price_cents
    end

    Store::StagedPurchase.includes(:product).where(user_id: user_id,
                                                   type_id: Store::StagedPurchase::TYPE_PHYSICAL_SINGLE).each do |sp|
      total += sp.product.physical_price_cents
    end
    total
  end

  def single?
    type_id == TYPE_DIGITAL_SINGLE
  end

  def gift_pack?
    type_id == TYPE_DIGITAL_GIFT_PACK
  end

  def physical_single?
    type_id == TYPE_PHYSICAL_SINGLE
  end

  # static

  def self.total_cart_shipping_for( user_id )
    total_shipping = 0
    Store::StagedPurchase.includes(:product).where(user_id: user_id,
                                                   type_id: Store::StagedPurchase::TYPE_PHYSICAL_SINGLE).each do |sp|
      total_shipping += sp.product.shipping_cost_cents
    end
    total_shipping
  end

end
