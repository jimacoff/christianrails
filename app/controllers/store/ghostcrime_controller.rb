class Store::GhostcrimeController < Store::StoreController

  layout "ghostcrime"

  skip_before_action :verify_is_admin, only: [:index]
  before_action :get_products, :get_cart, only: [:index]
  before_action :specialty_cart_add, only: [:index]

  ## PUBLIC

  def index
    @gc_product = Store::Product.where(title: "Ghostcrime").first
  end

end
