class Store::SnapbackController < Store::StoreController

  layout "snapback"

  skip_before_action :verify_is_admin,    only: [:fuseki, :shimari]
  before_action :get_products, :get_cart, only: [:fuseki, :shimari]

  ## PUBLIC

  def fuseki
    @sb_v1_product = Store::Product.where(title: "Snapback: Fuseki").first
  end

  def shimari
    @sb_v2_product = Store::Product.where(title: "Snapback: Shimari").first
  end

end
