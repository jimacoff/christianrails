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
    if current_user
      @cart[:books]  = {}.tap{ |hash| Store::StagedPurchase.where(user_id: current_user.id,
                                                                  type_id: Store::StagedPurchase::TYPE_DIGITAL_SINGLE)
                                                           .each{ |sp| hash[sp.product_id] = sp.id } }
      @cart[:giftpacks] = {}.tap{ |hash| Store::StagedPurchase.where(user_id: current_user.id,
                                                                     type_id: Store::StagedPurchase::TYPE_DIGITAL_GIFT_PACK)
                                                              .each{ |sp| hash[sp.product_id] = sp.id } }
      @cart[:prices] = get_updated_prices
    end
  end

  def get_updated_prices
    price_json = {}
    price_json[:total_discount] = Store::PriceCombo.total_cart_discount_for( current_user.id )

    @all_products.each do |prod|
      price_json[prod.id] = [ prod.price_cents, prod.discount_for(current_user.id) ] # this is a dumb format
    end
    price_json
  end

  def give_product_to_user!( product, user, origin )
    Store::FreeGift.create(product_id: product.id, recipient_id: user.id, origin: origin)
    record_gifting( Log::STORE, "Product #{product.title} given to #{user.fullname}")
  end

  def nudge_users_about_unsent_gifts
    last_week = DateTime.current - 1.week
    stale_gifts = Store::FreeGift.where(recipient_id: nil)
                                 .where('created_at < ?', last_week)
    nudgable_users = stale_gifts.collect{ |g| g.giver }.uniq
    nudgable_users.each do |user|
      # Temporarily cripple the constant nudging until email overhaul
      if !user.last_gift_nudge # || user.last_gift_nudge < last_week
        StoreMailer.gift_nudge( user.unsent_products[0], user ).deliver_now
        user.last_gift_nudge = DateTime.current
        user.save
        record_scheduled_event(Log::BACKEND,
          "Nudged #{user.full_name} about unsent gift(s).")
      end
    end
  end

  ###########
  private

    def gift_id_if_not_yet_sent(gift)
      gift.id if !gift.recipient
    end

end
