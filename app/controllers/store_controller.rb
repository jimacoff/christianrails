class StoreController < ApplicationController

  before_action :verify_is_admin, only: [:admin]

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
      price_json = get_updated_prices

      respond_to do |format|
        format.json { render json: price_json }
      end
    end
  end

  def check_out
    if current_user && current_user.staged_purchases.size > 0
      staged = current_user.staged_purchases
      titles = staged.collect{ |s| s.product.title }.join(' + ')

      total_cost = 0
      staged.map { |e| total_cost += e.product.price }
      total_cost -= PriceCombo.total_cart_discount_for(current_user.id)

      @payment = PayPal::SDK::REST::Payment.new({
        intent: 'sale',
        payer: {
          payment_method: 'paypal' 
        },
        redirect_urls: {
          return_url: complete_order_url,
          cancel_url: root_url 
        },
        transactions: [{
          amount: {
            total: total_cost.to_s,
            currency: 'CAD' 
          },
          description: titles + ' eBooks'
        }] 
      })

      if @payment.create
        # redirect off to PayPal to get approval
        redirect_url = @payment.links.find {|link| link.rel == 'approval_url'}
        redirect_to redirect_url.href
      else
        redirect_to root_url, notice: @payment.error
      end

    end
  end

  def complete_order 
    begin
      # gets params back --> :paymentId, :token, :PayerID
      # TODO sanitize and secure
      payment = PayPal::SDK::REST::Payment.find(params[:paymentId])
      payerId = params[:PayerID]
      payment.execute( payer_id: payerId )

      if current_user # TODO authenticate they are the ones checking out
        staged = current_user.staged_purchases

        staged.each do |staged_purchase|
          Purchase.create(user: current_user, product: staged_purchase.product)
          staged_purchase.destroy
        end
        note = 'Thanks for your support! Download your new books below.'
      else
        note = 'Please log in. If you are having difficulties, please contact the author.'
      end

    rescue => e
      note = "Error finding/executing payment. Please contact the author."
    end
    
    respond_to do |format|
      format.html { redirect_to root_path, notice: note }
    end

  end

  def download
    release_id = store_params[:release_id]
    if current_user
      begin
        release = Release.find(release_id)
      rescue
        Rails.logger.warn("Download attempted on invalid release id: #{release_id} by user id: #{current_user.id}.")
        return
      end
      product = release.product
      if current_user.has_product?(product.id)
        file_name = "#{product.title} - #{product.author}.#{release.format.downcase}"
        send_file "#{Rails.root}/../../downloads/#{file_name}"
        Download.create(user: current_user, release: release)
        return
      else
        Rails.logger.warn("Download attempted on unauthorized product id: #{product.id} by user id: #{current_user.id}.")
        return
      end
    end
    Rails.logger.warn("Unauthorized download attempted on release: #{release_id} by a guest user.")
  end

  private

  def get_updated_prices
    price_json = {}
    price_json[:total_discount] = PriceCombo.total_cart_discount_for(current_user.id).to_f

    @all_products.each do |prod|
      price_json[prod.id] = [prod.price.to_f, prod.discount_for(current_user.id).to_f]
    end
    price_json
  end

  def store_params
    params.permit(:release_id)
  end

end