class Store::PurchasesController < Store::StoreController

  ## ADMIN ONLY

  def index
    @purchases = Store::Purchase.all.includes(:product)
  end

end
