require 'pp'

class StagedPurchasesController < ApplicationController
  before_action :set_staged_purchase, only: [:destroy]

  # dashboard for admin
  def index
    @staged_purchases = StagedPurchase.all
  end

  def create
    if current_user
      @staged_purchase = StagedPurchase.new( user: current_user, product_id: staged_purchase_params['product_id'] )
      
      respond_to do |format|
        if @staged_purchase.save
          format.json { render json: {}, status: :created }
        else
          format.json { render json: {}, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    if current_user
      if @staged_purchase.user.id == current_user.id
        @staged_purchase.destroy
        format.json { head :no_content }
      end
    end
  end

  private
    def set_staged_purchase
      @staged_purchase = StagedPurchase.find(params[:id])
    end

    def staged_purchase_params
      params.require(:staged_purchase).permit(:product_id)
    end
end
