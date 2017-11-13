class Store::PriceCombo < ApplicationRecord
  has_and_belongs_to_many :products, inverse_of: :price_combos
  has_many :orders,                  inverse_of: :price_combo

  validates_presence_of :name, :discount_cents

  monetize :discount_cents

  def satisfied_for?(user_id)
    product_ids = self.products.collect(&:id)
    staged_ids  = Store::StagedPurchase.where(user_id: user_id).collect(&:product_id)
    product_ids - staged_ids == []
  end

  # static functions

  def self.combos_satisfied_for(user_id)
    sat = []
    Store::PriceCombo.all.each do |pc|
      sat << pc.id if pc.satisfied_for?(user_id)
    end
    sat
  end

  def self.total_cart_discount_for(user_id)
    total = 0
    Store::PriceCombo.all.each do |pc|
      total += pc.discount_cents if pc.satisfied_for?(user_id)
    end
    total
  end

end
