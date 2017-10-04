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
                                hash[gift.product_id] << gift.recipient_id
                              else
                                hash[gift.product_id] = [gift.recipient_id]
                              end
                            end
                          end
    @price_combos       = Store::PriceCombo.all
  end

  def get_cart
    @cart = current_user ? {}.tap{ |hash| Store::StagedPurchase.where(user_id: current_user.id)
                                                               .each{ |sp| hash[sp.product_id] = sp.id }
                                 } : {}
  end

  def give_product_to_user!( product, user, origin )
    Store::FreeGift.create(product_id: product.id, recipient_id: user.id, origin: origin)
    record_gifting( Log::STORE, "Product #{product.title} given to #{user.fullname}")
  end

end
