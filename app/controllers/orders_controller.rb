class OrdersController < ApplicationController
  skip_before_action :verify_is_admin, only: [:show, :receipts]
  before_action :set_order, only: [:show]

  def index
    @orders = Order.all
  end

  def show
    unless current_user && current_user == @order.user
      @order = nil
    end
  end

  def receipts
    if current_user
      @orders = current_user.orders
    end
  end

  private

    def order_params
      params.permit(:id)
    end

    def set_order
      @order = Order.find(order_params[:id])
    end
end
