class AddStorePrefixToStoreTables < ActiveRecord::Migration[5.0]
  def change
    rename_table :downloads, :store_downloads
    rename_table :orders, :store_orders
    rename_table :price_combos, :store_price_combos
    rename_table :price_combos_products, :store_price_combos_products
    rename_table :products, :store_products
    rename_table :purchases, :store_purchases
    rename_table :releases, :store_releases
    rename_table :staged_purchases, :store_staged_purchases
  end
end
