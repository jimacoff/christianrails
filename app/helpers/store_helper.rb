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
    price_json[:total_discount] = Store::PriceCombo.total_cart_discount_for( current_user.id ).to_f

    @all_products.each do |prod|
      price_json[prod.id] = [prod.price.to_f, prod.discount_for(current_user.id).to_f] # this is a dumb format
    end
    price_json
  end

  def give_product_to_user!( product, user, origin )
    Store::FreeGift.create(product_id: product.id, recipient_id: user.id, origin: origin)
    record_gifting( Log::STORE, "Product #{product.title} given to #{user.fullname}")
  end

  private

    def gift_id_if_not_yet_sent(gift)
      gift.id if !gift.recipient
    end

end
