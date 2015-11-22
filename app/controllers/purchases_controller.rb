class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:update, :destroy]

  # stats page for all purchases
  def index
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
