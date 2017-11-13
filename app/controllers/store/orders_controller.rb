class Store::OrdersController < Store::StoreController
  skip_before_action :verify_is_admin, only: [:show, :receipts]
  before_action :set_order_secure, only: [:show]

  ## PUBLIC

  def show
  end

  def receipts
    @orders = current_user.orders if current_user
  end

  ## ADMIN ONLY

  def index
    @orders = Store::Order.all
  end

  private

    def set_order_secure
      @order = Store::Order.find( params[:id] )
      redirect_to root_path unless current_user && current_user == @order.user
    end

end
