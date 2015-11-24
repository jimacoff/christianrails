class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:update, :destroy]
  before_action :verify_is_admin

  def index
    # stats page for all purchases
    @purchases = Purchase.all
  end

  private
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    def purchase_params
      params.require(:purchase).permit(:user_id, :product_id)
    end
end
