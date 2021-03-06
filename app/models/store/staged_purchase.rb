class Store::StagedPurchase < ApplicationRecord
  belongs_to :user
  belongs_to :product, optional: true

  validates_presence_of :user
  validate :has_product_if_required

  TYPE_DIGITAL_SINGLE     = 0
  TYPE_DIGITAL_GIFT_PACK  = 1

  TYPE_PHYSICAL_SINGLE    = 2
  TYPE_PHYSICAL_5_PACK    = 3
  TYPE_PHYSICAL_BUNDLE    = 4

  TYPE_LIFETIME_MEMBERSHIP = 5

  def single?
    type_id == TYPE_DIGITAL_SINGLE
  end

  def gift_pack?
    type_id == TYPE_DIGITAL_GIFT_PACK
  end

  def physical_single?
    type_id == TYPE_PHYSICAL_SINGLE
  end

  def lifetime_membership?
    type_id == TYPE_LIFETIME_MEMBERSHIP
  end

  # static

  def self.total_cart_shipping_for( user_id )
    total_shipping = 0
    Store::StagedPurchase.includes(:product).where(user_id: user_id,
                                                   type_id: Store::StagedPurchase::TYPE_PHYSICAL_SINGLE).each do |sp|
      if sp.product
        total_shipping += sp.product.shipping_cost_cents
      end
    end
    total_shipping
  end

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

    Store::StagedPurchase.where(user_id: user_id,
                                type_id: Store::StagedPurchase::TYPE_LIFETIME_MEMBERSHIP).each do |sp|
      total += Store::LifetimeMembership::CURRENT_PRICE_CENTS
    end
    total
  end

  private

    def has_product_if_required
      if !self.product && [ TYPE_DIGITAL_SINGLE, TYPE_DIGITAL_GIFT_PACK, TYPE_PHYSICAL_SINGLE,
                            TYPE_PHYSICAL_5_PACK, TYPE_PHYSICAL_BUNDLE ].include?( self.type_id )
        errors.add(:product_id, "required for this type of StagedPurchase")
      end
    end

end
