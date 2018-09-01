class Store::DealzoneController < Store::StoreController

  include BlogHelper

  before_action :get_products, :get_cart
  before_action :specialty_cart_add, only: [:index, :cart]
  before_action :get_sample_blog_posts, only: [:index]
  before_action :get_staged_purchases,  only: [:check_out, :complete_order]

  skip_before_action :verify_is_admin

  ## PUBLIC

  # GET - main page of site
  def index
    # fetch Diamond Find info for the Diamond Machine
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

    if @melon = (params[:melon] ? params[:melon].to_i : nil)
      if @melon == 3
        record_positive_event(Log::MELON, "A m3lonhacker got in!")
        render 'melon/3'
      elsif @melon > 3 || @melon < 0
        @melon = nil
      else
        record_positive_event(Log::MELON, "Initiated an #{ Melon::TYPE_NAMES[ @melon ] } melon store takeover!")
      end
    end
  end

  # GET - displays the user's downloadable books & givable gifts
  def library
  end

  # GET - page about lifetime memberships
  def memberships
  end

  # a page to facilitate the bulk-purchase of gifts for your friends
  # ROUTE DISABLED
  def gifts
    @available_gifts = @all_products.where(free_on_signup: false)
  end

  # GET - a dedicated page for viewing your cart & checking out
  def cart
    unless current_user
      redirect_to root_path
    end
  end

  ## GET - JSON
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

        checkout_description = generate_description_for_checkout

        gross_price_cents = calculate_gross_price_for_user
        total_tax_cents   = calculate_tax_for_user

        gross_price_formatted = ( gross_price_cents.to_f / 100.to_f ).round(2) # as decimal
        tax_formatted         = ( total_tax_cents / 100.to_f ).round(2)

        net_cost_with_tax = ( (gross_price_cents + total_tax_cents) / 100.to_f ).round(2)

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
              total: net_cost_with_tax,
              currency: 'CAD',
              details: {
                subtotal: gross_price_formatted,
                tax:      tax_formatted
              }
            },
            description: checkout_description
          }]
        })

        if @payment.create
          # redirect off to PayPal to get approval
          redirect_url = @payment.links.find {|link| link.rel == 'approval_url'}
          record_positive_event(Log::STORE, "Checkout initiated: #{ checkout_description }")
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
        tax      = calculate_tax_for_user
        shipping = calculate_total_shipping_for_user
        total = gross_price - discount + tax + shipping

        order = Store::Order.create(user: current_user,
                                    payer_id: params[:PayerID], payment_id: params[:paymentId],
                                    discount_cents: discount, tax_cents: tax, total_cents: total, shipping_cost_cents: shipping)
        for_self  = false
        gift_pack = false
        phys_single = false
        lifetime_membership = false

        # turn all StagedPurchases into DigitalPurchases, FreeGifts or PhysicalPurchases, depending
        staged.each do |staged_purchase|
          if staged_purchase.single?
            for_self = true
            Store::DigitalPurchase.create(product: staged_purchase.product,
                                          order: order,
                                          price_cents: staged_purchase.product.price_cents,
                                          type_id: Store::DigitalPurchase::TYPE_DIGITAL_SINGLE)
            # give them a giftable spare
            Store::FreeGift.create( product: staged_purchase.product,
                                    giver: current_user,
                                    origin: "Spare on purchase")

          elsif staged_purchase.gift_pack?
            gift_pack = true
            Store::DigitalPurchase.create(product: staged_purchase.product,
                                          order: order,
                                          price_cents: staged_purchase.product.giftpack_price_cents,
                                          type_id: Store::DigitalPurchase::TYPE_DIGITAL_GIFT_PACK)
            # give them the gifts to give
            Store::DigitalPurchase::GIFTPACK_SIZE.times do
              Store::FreeGift.create( product: staged_purchase.product,
                                      giver: current_user,
                                      origin: "Gift pack")
            end
          elsif staged_purchase.physical_single?
            phys_single = true
            Store::PhysicalPurchase.create(product: staged_purchase.product,
                                           order: order,
                                           price_cents: staged_purchase.product.physical_price_cents,
                                           type_id: Store::PhysicalPurchase::TYPE_PHYSICAL_SINGLE)
          elsif staged_purchase.lifetime_membership?
            lifetime_membership = true
            Store::LifetimeMembership.create(order: order,
                                             user_id: current_user.id,
                                             cost_cents: Store::LifetimeMembership::CURRENT_PRICE_CENTS)
          end

          staged_purchase.destroy
        end

        # custom note based on what they bought
        if lifetime_membership
          note = "Success! You're now a lifetime member. Download your books below."

        elsif phys_single && for_self && gift_pack
          note = "Success! Your shipment will be fulfilled shortly & you can find your digital copy and gift copies below."

        # 2 of a kind
        elsif phys_single && for_self
          note = "Success! Your shipment will be fulfilled shortly & you can read your digital copy immediately below."
        elsif phys_single && gift_pack
          note = "Success! Your shipment will be fulfilled shortly & you can send your gifts below."
        elsif for_self && gift_pack
          note = "Success! Download your books and send your gifts below."

        # one kind
        elsif phys_single
          note = "Success! Your shipment will be fulfilled shortly."
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
    flash[:notice] = "Order complete! Your book(s) will be shipped within 2 business days."
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
            send_file "#{Rails.root}/../../downloads/#{file_name}" if (Rails.env.production? || Rails.env.test?)
            Store::Download.create(user: current_user, release: release)
            record_positive_event(Log::STORE, "Download initiated for: #{file_name}.")
            notify_admin_of_product_download( current_user, product, release )
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

  # POST - records the opening of a 3D book
  def open_book
    if params[:slug] && (product = Store::Product.where(slug: params[:slug]).take)
      record_positive_event(Log::STORE, "Someone opened the 3D book of #{ product.title }!")
      render json: {}, status: :ok
    else
      render json: {errors: "Invalid book opened."}, status: :unprocessable_entity
    end
  end

  private

    def get_sample_blog_posts
      @blog_posts = sample_blog_posts
    end

    def get_staged_purchases
      @staged_products       = current_user ? current_user.staged_purchases.where( type_id: Store::StagedPurchase::TYPE_DIGITAL_SINGLE )    : []
      @staged_giftpacks      = current_user ? current_user.staged_purchases.where( type_id: Store::StagedPurchase::TYPE_DIGITAL_GIFT_PACK ) : []
      @staged_physical_books = current_user ? current_user.staged_purchases.where( type_id: Store::StagedPurchase::TYPE_PHYSICAL_SINGLE )   : []
      @staged_memberships    = current_user ? current_user.staged_purchases.where( type_id: Store::StagedPurchase::TYPE_LIFETIME_MEMBERSHIP ) : []
    end

    def generate_description_for_checkout
      if @staged_memberships.size > 0
        if @staged_products.size + @staged_giftpacks.size + @staged_physical_books.size > 3
          desc = "Lifetime Membership & books"
        else
          desc = "Lifetime Membership"
        end
      elsif @staged_products.size + @staged_giftpacks.size + @staged_physical_books.size > 3
        desc = "Assorted books"
      else
        desc = ""
        desc += @staged_products.collect{  |s| s.product.title }.join(' + ') + ' eBook' if @staged_products.size > 0
        desc += 's' if @staged_products.size > 1
        desc += " & " if desc != "" && @staged_giftpacks.size > 0
        desc += @staged_giftpacks.collect{ |s| s.product.title + " 5-pack" }.join(' + ') if @staged_giftpacks.size > 0
        desc += " & " if desc != "" && @staged_physical_books.size > 0
        desc += @staged_physical_books.collect{ |s| s.product.title + " paperback" }.join(' + ') if @staged_physical_books.size > 0
        desc
      end
    end

    def calculate_gross_price_for_user
      gross_price = 0

      @staged_products.map       { |s| gross_price += s.product.price_cents }
      @staged_giftpacks.map      { |s| gross_price += s.product.giftpack_price_cents }
      @staged_physical_books.map { |s| gross_price += s.product.physical_price_cents + s.product.shipping_cost_cents }
      @staged_memberships.map    { |s| gross_price += Store::LifetimeMembership::CURRENT_PRICE_CENTS }

      gross_price -= Store::PriceCombo.total_cart_discount_for( current_user.id )
      gross_price
    end

    def calculate_tax_for_user
      small_tax = 0
      large_tax = 0
      large_taxable_amount = 0

      # large tax, discounted
      @staged_products.map       { |st| large_taxable_amount += st.product.price_cents          }
      @staged_giftpacks.map      { |sg| large_taxable_amount += sg.product.giftpack_price_cents }
      @staged_memberships.map    { |sm| large_taxable_amount += Store::LifetimeMembership::CURRENT_PRICE_CENTS }
      discount = Store::PriceCombo.total_cart_discount_for( current_user.id )
      large_tax = (large_taxable_amount - discount).to_f * Store::DigitalPurchase::TAX_RATE

      # small tax
      @staged_physical_books.map { |sg| small_tax += sg.product.physical_price_cents.to_f * Store::PhysicalPurchase::TAX_RATE }
      (small_tax + large_tax).ceil
    end

    def calculate_total_shipping_for_user
      total_shipping = 0
      @staged_physical_books.map { |sp| total_shipping += sp.product.shipping_cost_cents }
      total_shipping
    end

    # email notifiers

    def notify_admin_of_product_download( user, product, release )
      AdminMailer.download_initiated( user, product, release ).deliver_now
    end

end
