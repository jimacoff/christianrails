class RemoveExcessPriceColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :store_digital_purchases, :price
    remove_column :store_orders,            :total
    remove_column :store_orders,            :tax
    remove_column :store_orders,            :discount
    remove_column :store_price_combos,      :discount
    remove_column :store_products,          :price
    remove_column :store_products,          :giftpack_price
  end
end
