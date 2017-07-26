class Store::SnapbackController < Store::StoreController

  layout "snapback"

  skip_before_action :verify_is_admin, only: [:index]
  before_action :get_products, :get_cart, only: [:index]

  ## PUBLIC

  def index
    @sb_v1_product = Store::Product.where(title: "Snapback: Fuseki").first
    @price_combos = Store::PriceCombo.all

    if current_user
      @owned_products = current_user.products.sort{ |a,b| a.rank <=> b.rank}
    else
      @owned_products = []
    end

    @available_products = @all_products - @owned_products
  end

end
