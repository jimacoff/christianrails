module StoreHelper

  def get_products
    @all_products = Product.order(:rank)
  end

  def get_cart
    @cart = current_user ? {}.tap{ |hash| StagedPurchase.where(user_id: current_user.id).each{ |sp| hash[sp.product_id] = sp.id } } : {}
  end

  def get_dealz
    @dealz = PriceCombo.all
  end

end
