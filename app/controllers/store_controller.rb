class StoreController < ApplicationController

  include BlogHelper

  skip_before_action :verify_is_admin
  before_action :get_sample_blog_posts, only: [:index]

  def index
    @price_combos = PriceCombo.all
    @owned_products = []

    if current_user
      @owned_products = current_user.products.sort{ |a,b| a.rank <=> b.rank}
      @finds = current_user.player.finds.joins(:item).where('woods_items.value > ?', 0) if current_user.player
    end
    @finds ||= nil

    @available_products = @all_products - @owned_products

    @gc_product = Product.where(title: "Ghostcrime").first
    @gc_crm = ""
    if @gc_product && current_user && store_params[:gc] == "crm"
      if @available_products.collect{ |x| x.id }.include?( @gc_product.id )
        @gc_crm = "add-to-cart"
      end
    end

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
      titles = staged.collect{ |s| s.product.title }

      total_cost = 0
      staged.map { |st| total_cost += st.product.price }
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
            total: '%.2f' % (total_cost * (1 + Purchase::TAX_RATE) ).round(2).to_s,
            currency: 'CAD',
            details: {
              subtotal: total_cost.to_s,
              tax: '%.2f' % (total_cost * Purchase::TAX_RATE ).round(2).to_s
            }
          },
          description: titles.join(' + ') + ' eBooks'
        }]
      })

      if @payment.create
        # redirect off to PayPal to get approval
        redirect_url = @payment.links.find {|link| link.rel == 'approval_url'}
        render js: "window.location = '#{redirect_url.href}'"
      else
        flash[:alert] = @payment.error
        render js: "window.location = '#{root_url}'"
      end

    end
  end

  def complete_order
    begin
      if current_user
        # gets params back --> :paymentId, :token, :PayerID
        payment = PayPal::SDK::REST::Payment.find(store_params[:paymentId])
        payment.execute( payer_id: store_params[:PayerID] )

        staged = current_user.staged_purchases
        gross_price = StagedPurchase.gross_cart_value_for(current_user.id)
        discount = PriceCombo.total_cart_discount_for(current_user.id)
        tax = (gross_price - discount) * Purchase::TAX_RATE

        order = Order.create(user: current_user, payer_id: store_params[:PayerID], payment_id: store_params[:paymentId],
                             discount: discount, tax: tax, total: gross_price - discount + tax)

        staged.each do |staged_purchase|
          Purchase.create(product: staged_purchase.product, order: order, price: staged_purchase.product.price)
          staged_purchase.destroy
        end

        note = 'Thanks for your support! Download your new books below.'
      else
        alert = 'Please log in. If you are having difficulties, please contact the author.'
      end

    rescue => e
      alert = "Error executing payment. Please contact the author."
      Rails.logger.error(e.to_s)
    end

    respond_to do |format|
      flash[:notice] = note if note
      flash[:alert] = alert if alert
      format.html { redirect_to root_path }
    end

  end

  def download
    release_id = store_params[:release_id]
    if current_user
      begin
        release = Release.find(release_id)
        product = release.product
      rescue
        @error = "Download attempted on invalid release id: #{release_id} by user id: #{current_user.id}."
      end

      if !@error
        if current_user.has_product?(product.id)
          if current_user.downloads.where(release_id: release.id).size >= Download::LIMIT
            @error = "Download limit of #{Download::LIMIT} reached on release id: #{release_id} by user id: #{current_user.id}."
          else
            file_name = "#{product.title} - #{product.author}.#{release.format.downcase}"
            send_file "#{Rails.root}/../../downloads/#{file_name}"
            Download.create(user: current_user, release: release)
            return
          end
        else
          @error = "Download attempted on unauthorized product id: #{product.id} by user id: #{current_user.id}."
        end
      end

    else
      @error = "Unauthorized download attempted on release: #{release_id} by a guest user."
    end

    Rails.logger.warn(@error)

    respond_to do |format|
      flash[:alert] = @error
      format.html { redirect_to root_path }
    end

  end

  def order_success
    respond_to do |format|
      flash[:notice] = "Order complete! Your book(s) will be shipped within 48 hours."
      format.html { redirect_to root_path }
    end
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
    params.permit(:release_id, :paymentId, :token, :PayerID, :gc)
  end

  def get_sample_blog_posts
    @blog_posts = sample_blog_posts
  end

end
