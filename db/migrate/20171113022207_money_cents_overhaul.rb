class MoneyCentsOverhaul < ActiveRecord::Migration[5.0]
  def change

    add_column :store_digital_purchases,  :price_cents,          :integer
    add_column :store_orders,             :total_cents,          :integer
    add_column :store_orders,             :tax_cents,            :integer
    add_column :store_orders,             :discount_cents,       :integer
    add_column :store_price_combos,       :discount_cents,       :integer
    add_column :store_products,           :price_cents,          :integer
    add_column :store_products,           :giftpack_price_cents, :integer

    # convert all
    Store::DigitalPurchase.all.each do |dp|
      dp.price_cents = dp.price.round(2) * 100   if dp.price
      dp.save
    end
    Store::Order.all.each do |o|
      o.total_cents    = o.total.round(2) * 100    if o.total
      o.tax_cents      = o.tax.round(2) * 100  if o.tax
      o.discount_cents = o.discount.round(2) * 100  if o.discount
      o.save
    end
    Store::PriceCombo.all.each do |pc|
      pc.discount_cents = pc.discount.round(2) * 100  if pc.discount
      pc.save
    end
    Store::Product.all.each do |p|
      p.price_cents          = p.price.round(2) * 100  if p.price
      p.giftpack_price_cents = p.giftpack_price.round(2) * 100  if p.giftpack_price
      p.save
    end

  end
end
