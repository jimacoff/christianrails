module StoreHelper

  def get_cart
    @cart = current_user ? StagedPurchase.where(user: current_user.id) : []
  end

end
