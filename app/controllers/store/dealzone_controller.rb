class Store::DealzoneController < Store::StoreController

  include BlogHelper

  before_action :get_products, :get_cart
  before_action :get_sample_blog_posts, only: [:index]
  before_action :get_staged_purchases,  only: [:check_out]

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

  # POST
  def check_out
    if current_user
      target_urls = {}

      if current_user.staged_purchases.size > 0
        target_urls[:complete] = complete_order_url
        target_urls[:abort]    = root_url

        desc = generate_description_for_checkout
        total_cost_cents = calculate_total_cost_for_user
        total_cost          = ( total_cost_cents.to_f / 100.to_f ).round(2)
        total_cost_with_tax = ( (total_cost_cents * ( Store::DigitalPurchase::TAX_RATE + 1 ) ) / 100.to_f ).round(2)
        tax_formatted       = ( (total_cost_cents *   Store::DigitalPurchase::TAX_RATE )       / 100.to_f ).round(2)

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
              total: total_cost_with_tax,
              currency: 'CAD',
              details: {
                subtotal: total_cost,
                tax:      tax_formatted
              }
            },
            description: desc
          }]
        })

        if @payment.create
          # redirect off to PayPal to get approval
          redirect_url = @payment.links.find {|link| link.rel == 'approval_url'}
          record_positive_event(Log::STORE, "Checkout initiated: #{desc}")
          render js: "window.location = '#{ redirect_url.href }'"
        else
          flash[:alert] = @payment.error
          render js: "window.location = '#{ target_urls[:abort] }'"
        end

      else
        flash[:alert] = "You don't have anything in your cart."
        redirect_to root_path
      end

    else
      flash[:alert] = "You are not logged in."
      redirect_to root_path
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
                                    discount_cents: discount, tax_cents: tax, total_cents: total)
        for_self  = false
        gift_pack = false

        # turn all StagedPurchases into DigitalPurchases or FreeGifts, depending
        staged.each do |staged_purchase|
          if staged_purchase.single?
            for_self = true
            Store::DigitalPurchase.create(product: staged_purchase.product,
                                          order: order,
                                          price: staged_purchase.product.price_cents,
                                          type_id: Store::DigitalPurchase::TYPE_DIGITAL_SINGLE)
            # give them a giftable spare
            Store::FreeGift.create( product: staged_purchase.product,
                                    giver: current_user,
                                    origin: "Spare on purchase")

          elsif staged_purchase.gift_pack?
            gift_pack = true
            Store::DigitalPurchase.create(product: staged_purchase.product,
                                          order: order,
                                          price: staged_purchase.product.giftpack_price_cents,
                                          type_id: Store::DigitalPurchase::TYPE_DIGITAL_GIFT_PACK)
            # give them the gifts to give
            Store::DigitalPurchase::GIFTPACK_SIZE.times do
              Store::FreeGift.create( product: staged_purchase.product,
                                      giver: current_user,
                                      origin: "Gift pack")
            end
          end

          staged_purchase.destroy
        end

        # custom note based on what they bought
        if for_self && gift_pack
          note = "Success! Download your books and send your gifts below."
        elsif for_self
          note = "Success! Download your books below & share a free copy with a friend."
        elsif gift_pack
          note = "Success! Send your gifts below."
        else
          note = "Success!" ## but shouldn't happen
        end
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

  # for physical books
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

    def get_sample_blog_posts
      @blog_posts = sample_blog_posts
    end

    def get_staged_purchases
      @staged_products  = current_user ? current_user.staged_purchases.where( type_id: Store::StagedPurchase::TYPE_DIGITAL_SINGLE )    : []
      @staged_giftpacks = current_user ? current_user.staged_purchases.where( type_id: Store::StagedPurchase::TYPE_DIGITAL_GIFT_PACK ) : []
    end

    def generate_description_for_checkout
      desc = ""
      desc += @staged_products.collect{  |s| s.product.title }.join(' + ') + ' eBook' if @staged_products.size > 0
      desc += 's' if @staged_products.size > 1
      desc += " & " if desc != "" && @staged_giftpacks.size > 0
      desc += @staged_giftpacks.collect{ |s| s.product.title + " 5-pack" }.join(' + ') if @staged_giftpacks.size > 0
      desc
    end

    def calculate_total_cost_for_user
      total_cost = 0
      @staged_products.map  { |st| total_cost += st.product.price_cents }
      @staged_giftpacks.map { |sg| total_cost += sg.product.giftpack_price_cents }
      total_cost -= Store::PriceCombo.total_cart_discount_for( current_user.id )
      total_cost
    end

end
