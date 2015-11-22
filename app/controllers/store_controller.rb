class StoreController < ApplicationController

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
    # TODO checkout function    


  end

  def download(release_id)
    if current_user
      begin
        release = Release.find(release_id)
      rescue
        Rails.logger.warn("Ebook download attempted on invalid release id: #{release_id} by user id: #{current_user.id}.")
        return
      end
      product = release.product
      if current_user.has_product?(product_id)
        send_file "#{Rails.root}/../../downloads/#{release.file_name}"
        Download.create(user: current_user, release: release)
        return
      else
        Rails.logger.warn("Ebook download attempted on unauthorized product id: #{product.id} by user id: #{current_user.id}.")
        return
      end
    end
    Rails.logger.warn("Unauthorized download attempted on release: #{release_id} by a guest user.")
  end

end