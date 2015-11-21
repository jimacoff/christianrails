class MainController < ApplicationController

  def index
    @price_combos = PriceCombo.all
    @owned_products = []

    if current_user
      @owned_products = current_user.products
    end

    @available_products = @all_products - @owned_products
  end

  def admin
  end

end
