class StoreController < ApplicationController

  include StoreHelper

  before_filter :get_cart

  def index
    @price_combos = PriceCombo.all
    @all_products = Product.all
    @owned_products = []
    if current_user
      @owned_products = current_user.products
    end
    @available_products = @all_products - @owned_products
  end

end