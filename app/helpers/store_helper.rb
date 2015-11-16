module StoreHelper

  def get_products
    @all_products = Product.all
  end

  def get_cart
    @cart = current_user ? {}.tap{ |hash| StagedPurchase.where(user_id: current_user.id).each{ |sp| hash[sp.product_id] = sp.id } } : {}
  end

end
