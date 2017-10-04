class Store::DealzoneController < Store::StoreController

  include BlogHelper

  before_action :get_products, :get_cart
  before_action :get_sample_blog_posts, only: [:index]

  skip_before_action :verify_is_admin

  ## PUBLIC

  def index
    @diamondfind = Woods::Story.where(name: "Diamond Find").first

    if current_user
      @finds = current_user.player.finds.joins(:item)
                                        .where('woods_items.value > ?', 0)
                                        .where('woods_finds.story_id = ?', @diamondfind.id) if current_user.player
    elsif !current_user && current_player
      @finds = current_player.finds.joins(:item).where('woods_items.value > ?', 0)
                                                .where('woods_finds.story_id = ?', @diamondfind.id)
    end
    @finds ||= nil

    # for auto-adding of GC from the params
    @gc_product = Store::Product.where(title: "Ghostcrime").first
    @gc_crm = ""
    if @gc_product && current_user && params[:gc] == "crm"
      if @available_products.collect{ |x| x.id }.include?( @gc_product.id )
        @gc_crm = "add-to-cart"
        record_positive_event(Log::STORE, "Ghostcrime added to cart from CRM")
      end
    end

  end

  # GET - displays the user's downloadable books & givable gifts
  def library
  end

  # a page to facilitate the bulk-purchase of gifts for your friends
  def gifts
    @available_gifts = @all_products.where(free_on_signup: false)
  end

  # a dedicated page for viewing your cart & checking out
  def cart
    unless current_user
      redirect_to root_path
    end
  end

  ## JSON
  def updated_prices
    if current_user
      respond_to do |format|
        format.json { render json: get_updated_prices }
      end
    end
  end

  def check_out
    if current_user

      target_urls = {}

      if params[:target] == "cart" && current_user.staged_purchases.size > 0
        target_urls[:complete] = complete_order_url
        target_urls[:abort]    = root_url

        staged = current_user.staged_purchases
        desc = staged.collect{ |s| s.product.title }.join(' + ') + ' eBooks'
        total_cost = 0
        staged.map { |st| total_cost += st.product.price }
        total_cost -= Store::PriceCombo.total_cart_discount_for( current_user.id )

      elsif params[:target] == "gifts"
        target_urls[:complete] = complete_gift_order
        target_urls[:abort]    = gifts_url

        # TODO calculate cost + discount for gifts in the gift basket
        product = Store::Product.find( params[:gifts] )
        @staged_purchase = Store::StagedPurchase.where(user: current_user, product_id: product.id).first
        @staged_purchase ||= Store::StagedPurchase.new(user: current_user, product_id: product.id)
      end

      @payment = PayPal::SDK::REST::Payment.new({
        intent: 'sale',
        payer: {
          payment_method: 'paypal'
        },
        redirect_urls: {
          return_url: target_urls[:complete],
          cancel_url: target_urls[:abort]
        },
        transactions: [{
          amount: {
            total: '%.2f' % (total_cost * (1 + Store::DigitalPurchase::TAX_RATE) ).round(2).to_s,
            currency: 'CAD',
            details: {
              subtotal: total_cost.to_s,
              tax: '%.2f' % (total_cost * Store::DigitalPurchase::TAX_RATE ).round(2).to_s
            }
          },
          description: desc
        }]
      })

      if @payment.create
        # redirect off to PayPal to get approval
        redirect_url = @payment.links.find {|link| link.rel == 'approval_url'}
        record_positive_event(Log::STORE, "Checkout initiated: #{desc}")
        render js: "window.location = '#{redirect_url.href}'"
      else
        flash[:alert] = @payment.error
        render js: "window.location = '#{ target_urls[:abort] }'"
      end
    else
      # TODO no user error
    end
  end

  # gets params back from paypal --> :paymentId, :token, :PayerID
  def complete_order
    begin
      if current_user
        payment = PayPal::SDK::REST::Payment.find( params[:paymentId] )
        payment.execute( payer_id: params[:PayerID] )

        staged = current_user.staged_purchases
        gross_price = Store::StagedPurchase.gross_cart_value_for( current_user.id )
        discount    = Store::PriceCombo.total_cart_discount_for( current_user.id )
        tax  = (gross_price - discount) * Store::DigitalPurchase::TAX_RATE
        total = gross_price - discount + tax

        order = Store::Order.create(user: current_user,
                                    payer_id: params[:PayerID], payment_id: params[:paymentId],
                                    discount: discount, tax: tax, total: total)

        # turn all StagedPurchases into DigitalPurchases
        staged.each do |staged_purchase|
          Store::DigitalPurchase.create(product: staged_purchase.product,
                                        order: order,
                                        price: staged_purchase.product.price)
          staged_purchase.destroy
        end

        note = 'Order successful! Download your new books below.'
        record_positive_event(Log::STORE, "Checkout completed for $#{total}")

        StoreMailer.ebook_receipt( order ).deliver_now
      else
        alert = 'Please log in. If you are having difficulties, please contact the author.'
      end

    rescue => e
      alert = "Error executing payment. Please contact the author."
      Rails.logger.error(e.to_s)
    end

    flash[:notice] = note if note
    flash[:alert] = alert if alert

    redirect_to root_path
  end

  # gets params back from paypal --> :paymentId, :token, :PayerID
  def complete_gift_order
    begin
      if current_user
        payment = PayPal::SDK::REST::Payment.find( params[:paymentId] )
        payment.execute( payer_id: params[:PayerID] )

        # TODO calculate discount, tax, total
        staged = current_user.staged_purchases
        gross_price = Store::StagedPurchase.gross_cart_value_for( current_user.id )
        discount    = Store::PriceCombo.total_cart_discount_for( current_user.id )
        tax  = (gross_price - discount) * Store::DigitalPurchase::TAX_RATE
        total = gross_price - discount + tax

        order = Store::Order.create(user: current_user,
                                    payer_id: params[:PayerID], payment_id: params[:paymentId],
                                    discount: discount, tax: tax, total: total)

        # TODO turn staged gifts into actual purchases
        staged.each do |staged_purchase|
          Store::DigitalPurchase.create(product: staged_purchase.product,
                                        order: order,
                                        price: staged_purchase.product.price)
          staged_purchase.destroy
        end

        note = 'Your gifts have been sent!'
        record_positive_event(Log::STORE, "Gifting checkout completed for $#{total}")

        # TODO make a custom receipt?
        StoreMailer.ebook_receipt( order ).deliver_now
      else
        alert = 'Please log in. If you are having difficulties, please contact the author.'
      end

    rescue => e
      alert = "Error executing payment. Please contact the author."
      Rails.logger.error(e.to_s)
    end

    flash[:notice] = note if note
    flash[:alert] = alert if alert

    redirect_to gifts_path
  end

  def order_success
    flash[:notice] = "Order complete! Your book(s) will be shipped within 48 hours."
    redirect_to root_path
  end

  def download
    release_id = params[:release_id]
    if current_user
      begin
        release = Store::Release.find(release_id)
        product = release.product
      rescue
        @error = "Download attempted on invalid release id: #{release_id} by user id: #{current_user.id}."
      end

      if !@error
        if current_user.has_product?(product.id)
          if current_user.downloads.where(release_id: release.id).size >= Store::Download::LIMIT
            @error = "Download limit of #{Store::Download::LIMIT} reached on #{product.title} #{release.format} by user: #{current_user.username}."
          else
            file_name = "#{product.filename} - #{product.author}.#{release.format.downcase}"
            send_file "#{Rails.root}/../../downloads/#{file_name}"
            Store::Download.create(user: current_user, release: release)
            record_positive_event(Log::STORE, "Download initiated for: #{file_name}")
            return
          end
        else
          @error = "Download attempted on unauthorized product id: #{product.id} by user id: #{current_user.id}."
        end
      end

    else
      @error = "Unauthorized download attempted on release: #{release_id} by a guest user."
    end

    record_suspicious_event(Log::STORE, @error)
    flash[:alert] = @error
    redirect_to root_path
  end

  private

    def get_updated_prices
      price_json = {}
      price_json[:total_discount] = Store::PriceCombo.total_cart_discount_for(current_user.id).to_f

      @all_products.each do |prod|
        price_json[prod.id] = [prod.price.to_f, prod.discount_for(current_user.id).to_f]
      end
      price_json
    end

    def get_sample_blog_posts
      @blog_posts = sample_blog_posts
    end

end
