class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:update, :destroy]

  # stats page for all purchases
  def index
    @purchases = Purchase.all
  end

  def create
    @purchase = Purchase.new(purchase_params)

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to store_path, notice: 'Item purchased.' }
        format.json { render @purchase, status: :created }
      else
        format.html { redirect_to store_path }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    def purchase_params
      params.require(:purchase).permit(:user_id, :product_id)
    end
end
