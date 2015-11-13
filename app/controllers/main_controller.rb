class MainController < ApplicationController

  def index
  end

  def admin
  end

  def store
    @price_combos = PriceCombo.all
    @all_products = Product.all
    @owned_products = []
    if current_user
      @owned_products = current_user.products
    end
    @available_products = @all_products - @owned_products
  end
  
end
