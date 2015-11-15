class StagedPurchasesController < ApplicationController
  before_action :set_staged_purchase, only: [:destroy]

  # dashboard for admins
  def index
    @staged_purchases = StagedPurchase.all
  end

  def create
    @staged_purchase = StagedPurchase.new(staged_purchase_params)

    respond_to do |format|
      if @staged_purchase.save
        format.html { redirect_to @staged_purchase, notice: 'Staged purchase was successfully created.' }
        format.json { status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @staged_purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @staged_purchase.destroy
    respond_to do |format|
      format.html { redirect_to staged_purchases_url }
      format.json { head :no_content }
    end
  end

  private
    def set_staged_purchase
      @staged_purchase = StagedPurchase.find(params[:id])
    end

    def staged_purchase_params
      params[:staged_purchase]
    end
end
