class PurchasesController < ApplicationController
  before_action :verify_is_admin

  def index
    # TODO include user and product
    @purchases = Purchase.all
  end

  private

    def purchase_params
      params.require(:purchase).permit(:user_id, :product_id)
    end
end
