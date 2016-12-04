class PurchasesController < ApplicationController

  ## ADMIN ONLY

  def index
    @purchases = Purchase.all.includes(:product)
  end

  def user_report
    @users = User.all.order('created_at DESC')
  end

end
