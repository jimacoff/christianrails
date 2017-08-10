class Store::DigitalPurchasesController < Store::StoreController

  ## ADMIN ONLY

  def index
    @digital_purchases = Store::DigitalPurchase.all.includes(:product)
  end

end
