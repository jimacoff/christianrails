class StagedPurchasesController < ApplicationController
  before_action :set_staged_purchase, only: [:destroy]
  skip_before_action :verify_is_admin, only: [:create, :destroy]

  def index
    # dashboard for admin
    @staged_purchases = StagedPurchase.all
  end

  def create
    if current_user

      @staged_purchase = StagedPurchase.where( user: current_user, product_id: staged_purchase_params['product_id']).first
      @staged_purchase ||= StagedPurchase.new( user: current_user, product_id: staged_purchase_params['product_id'] )

      respond_to do |format|
        if @staged_purchase.save
          format.json { render json: @staged_purchase, status: :created }
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
      end

      respond_to do |format|
        format.json { render json: @staged_purchase }
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
