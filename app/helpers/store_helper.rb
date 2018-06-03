module StoreHelper
  include LogHelper

  def get_products
    @all_products       = Store::Product.order(:rank)
    @owned_products     = current_user ? current_user.products.sort{ |a,b| a.rank <=> b.rank} : []
    @available_products = @all_products - @owned_products
    @giftable_products  = current_user ? current_user.given_gifts.collect{ |g| g.product }.sort{ |a,b| a.rank <=> b.rank} : []
    @sendable_gifts     = current_user ? current_user.given_gifts : []
    @sendables          = {}.tap do |hash|
                            @sendable_gifts.each do |gift|
                              if hash[gift.product_id]
                                hash[gift.product_id] << gift_id_if_not_yet_sent(gift)
                              else
                                hash[gift.product_id] = [gift_id_if_not_yet_sent(gift)]
                              end
                            end
                          end
    @price_combos = Store::PriceCombo.all
  end

  def get_cart
    @cart = {}
    @cartsize = 0
    if current_user
      @cart[:books]  = {}.tap{ |hash| Store::StagedPurchase.where(user_id: current_user.id,
                                                                  type_id: Store::StagedPurchase::TYPE_DIGITAL_SINGLE)
                                                           .each{ |sp| hash[sp.product_id] = sp.id } }
      @cart[:giftpacks] = {}.tap{ |hash| Store::StagedPurchase.where(user_id: current_user.id,
                                                                     type_id: Store::StagedPurchase::TYPE_DIGITAL_GIFT_PACK)
                                                              .each{ |sp| hash[sp.product_id] = sp.id } }
      @cart[:physicalbooks] = {}.tap{ |hash| Store::StagedPurchase.where(user_id: current_user.id,
                                                                     type_id: Store::StagedPurchase::TYPE_PHYSICAL_SINGLE)
                                                              .each{ |sp| hash[sp.product_id] = sp.id } }
      @cart[:memberships] = {}.tap{ |hash| Store::StagedPurchase.where(user_id: current_user.id,
                                                                     type_id: Store::StagedPurchase::TYPE_LIFETIME_MEMBERSHIP)
                                                              .each{ |sp| hash['membership'] = sp.id } }
      @cart[:prices] = get_updated_prices

      @cartsize = @cart[:books].keys.length +
                  @cart[:giftpacks].keys.length +
                  @cart[:physicalbooks].keys.length +
                  @cart[:memberships].keys.length
    end
  end

  def get_updated_prices
    price_json = {}
    price_json[:total_discount] = Store::PriceCombo.total_cart_discount_for( current_user.id )
    price_json[:total_shipping] = Store::StagedPurchase.total_cart_shipping_for( current_user.id )

    @all_products.each do |prod|
      price_json[prod.id] = [ prod.price_cents, prod.discount_for(current_user.id) ] # this is a dumb format
    end
    price_json['membership'] = [ Store::LifetimeMembership::CURRENT_PRICE_CENTS, 0 ] # no discount
    price_json
  end

  def give_product_to_user!( product, user, origin )
    Store::FreeGift.create(product_id: product.id, recipient_id: user.id, origin: origin)
    record_gifting( Log::STORE, "Product #{product.title} given to #{user.fullname}")
  end

  def nudge_users_about_unsent_gifts
    last_week = DateTime.current - 1.week
    stale_gifts = Store::FreeGift.where(recipient_id: nil).where('created_at < ?', last_week)
    nudgable_users = stale_gifts.collect{ |g| g.giver }.uniq.select{ |x| x.send_me_emails }
    nudgable_users.each do |user|
      if !user.last_gift_nudge
        StoreMailer.gift_nudge( user.unsent_products[0], user ).deliver_now
        user.last_gift_nudge = DateTime.current
        user.save
        record_scheduled_event(Log::BACKEND, "Nudged #{user.full_name} about unsent gift(s).")
      end
    end
  end

  # Adding items to cart based on a click
  def specialty_cart_add
    # Adding Ghostcrime from ghostCRM
    if params[:gc] == "crm"
      if @gc_product = Store::Product.where(title: "Ghostcrime").first
        if current_user && @available_products.collect{ |x| x.id }.include?( @gc_product.id )
          @gc_crm = "add-to-cart"
          record_positive_event(Log::STORE, "Ghostcrime added to cart from CRM")
        end
      end
    end

    if params[:membership] == "lifetime"
      @lifemem = "add-to-cart"
      record_positive_event(Log::STORE, "Lifetime Membership added to cart from memberships page")
    end
  end

  ###########
  private

    def gift_id_if_not_yet_sent(gift)
      gift.id if !gift.recipient
    end

end
