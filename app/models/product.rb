class Product < ActiveRecord::Base
  has_many :releases, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :releases
  
  has_many :purchases, inverse_of: :product
  has_many :users, through: :purchases
  has_and_belongs_to_many :price_combos, inverse_of: :products

  validates_presence_of :title, :author, :price
  validates_numericality_of :price, :rank

  def discount_for(user_id)
    total_discount = 0
    cart_products = StagedPurchase.where(user_id: user_id).collect(&:product_id)

    PriceCombo.all.each do |combo|
      give_discount = true
      combo_product_ids = combo.products.collect(&:id)
      # check each combo to see if it includes current product
      if combo_product_ids.include?(self.id)
        # if so, remove it from the array and check if the others are in cart
        combo_product_ids -= [self.id]
        combo_product_ids.each do |prod_id|
          if !cart_products.include?(prod_id)
            give_discount = false
          end
        end
        total_discount += combo.discount if give_discount
      end
    end
    total_discount
  end

end
