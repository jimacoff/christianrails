module StoreHelper
  include LogHelper

  def get_products
    @all_products = Store::Product.order(:rank)
  end

  def get_cart
    @cart = current_user ? {}.tap{ |hash| Store::StagedPurchase.where(user_id: current_user.id).each{ |sp| hash[sp.product_id] = sp.id } } : {}
  end

  def give_product_to_user!( product, user, origin )
    Store::FreeGift.create(product_id: product.id, user_id: user.id, origin: origin)
    record_gifting( Log::STORE, "Product #{product.title} given to #{user.fullname}")
  end

end
