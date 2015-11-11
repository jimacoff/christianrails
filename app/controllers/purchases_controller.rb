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
        format.html { redirect_to @purchase, notice: 'Purchase was successfully created.' }
        format.json { render @purchase, status: :created }
      else
        format.html { redirect_to root_path }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    def purchase_params
      params.require(:purchase).permit()
    end
end
