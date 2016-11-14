class Product < ActiveRecord::Base

  STANDARD_SHIPPING   = 5

  has_many :releases, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :releases

  has_many :downloads, through: :releases, inverse_of: :product

  has_many :purchases, inverse_of: :product
  has_and_belongs_to_many :price_combos, inverse_of: :products

  validates_presence_of :title, :author, :price
  validates_numericality_of :price, :rank

  def discount_for(user_id)
    total_discount = 0
    cart_products = StagedPurchase.where(user_id: user_id).collect(&:product_id)

    PriceCombo.all.each do |combo|
      potential_discount = true
      combo_product_ids = combo.products.collect(&:id)
      # check each combo to see if it includes current product
      if combo_product_ids.include?(self.id)
        # if so, remove it from the array and check if the others are in cart
        combo_product_ids -= [self.id]

        combo_product_ids.each do |other_prod_in_combo|
          if !cart_products.include?(other_prod_in_combo)
            # short circuit the discount if cart does not include one of the other necessary products
            potential_discount = false
          end
        end
        total_discount += combo.discount if potential_discount
      end
    end
    total_discount
  end

  def digital_releases
    self.releases.where.not(format: "Book")
  end

  def has_physical_release?
    self.releases.each do |r|
      return true if r.format == "Book"
    end
    false
  end

  def has_digital_release?
    digital_releases.count > 0
  end

  def physical_code
    self.releases.each do |r|
      return r.physical_code if !r.physical_code.nil?
    end
    nil
  end

end
