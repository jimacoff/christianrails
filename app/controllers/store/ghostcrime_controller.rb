class Store::GhostcrimeController < Store::StoreController

  layout "ghostcrime"

  skip_before_action :verify_is_admin, only: [:index]
  before_action :get_products, :get_cart, only: [:index]

  ## PUBLIC

  def index
    @gc_product = Store::Product.where(title: "Ghostcrime").first

    # for auto-adding of GC from the params
    @gc_crm = ""
    if @gc_product && current_user && params[:gc] == "crm"
      if @available_products.collect{ |x| x.id }.include?( @gc_product.id )
        @gc_crm = "add-to-cart"
        record_positive_event(Log::STORE, "Ghostcrime added to cart from CRM")
      end
    end

  end

end
