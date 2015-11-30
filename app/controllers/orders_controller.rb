class OrdersController < ApplicationController
  before_action :verify_is_admin

  def index
    @orders = Order.all
  end

  private

    def order_params
      params.require(:order).permit(:payer_id, :payment_id, :price_combo_id)
    end
end
