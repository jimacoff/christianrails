class PriceCombo < ActiveRecord::Base
  has_and_belongs_to_many :products, inverse_of: :price_combos
  has_many :orders, inverse_of: :price_combo

  validates_presence_of :name, :discount
  validates_numericality_of :discount

  def satisfied_for?(user_id)
    product_ids = self.products.collect(&:id)
    staged_ids = StagedPurchase.where(user_id: user_id).collect(&:product_id)
    return true if product_ids - staged_ids == []
    false
  end

  def self.combos_satisfied_for(user_id)
    sat = []
    PriceCombo.all.each do |pc|
      sat << pc.id if pc.satisfied_for?(user_id)
    end
    sat
  end

  def self.total_cart_discount_for(user_id)
    total = 0
    PriceCombo.all.each do |pc|
      total += pc.discount if pc.satisfied_for?(user_id)
    end
    total
  end

end
