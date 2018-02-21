class Store::PhysicalPurchasesController < Store::StoreController

  ## ADMIN ONLY

  def index
    @physical_purchases = Store::PhysicalPurchase.all.includes(:product)
  end

end
