class AddDefaultsForMoneyFields < ActiveRecord::Migration[5.0]
  def change
    change_column :store_digital_purchases,  :price_cents,          :integer, default: 0
    change_column :store_orders,             :total_cents,          :integer, default: 0
    change_column :store_orders,             :tax_cents,            :integer, default: 0
    change_column :store_orders,             :discount_cents,       :integer, default: 0
    change_column :store_price_combos,       :discount_cents,       :integer, default: 0
    change_column :store_products,           :price_cents,          :integer, default: 0
    change_column :store_products,           :giftpack_price_cents, :integer, default: 0
  end
end
