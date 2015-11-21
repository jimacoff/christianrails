class StoreController < ApplicationController

  def updated_prices
    if current_user
      price_json = {}
      price_json[:total_discount] = PriceCombo.total_cart_discount_for(current_user.id).to_f

      @all_products.each do |prod|
        price_json[prod.id] = [prod.price.to_f, prod.discount_for(current_user.id).to_f]
      end

      respond_to do |format|
        format.json { render json: price_json }
      end

    end
  end

  def check_out
    


  end

end