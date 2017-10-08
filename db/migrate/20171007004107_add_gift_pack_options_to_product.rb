class AddGiftPackOptionsToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :store_products, :giftpackable, :boolean, default: false
    add_column :store_products, :giftpack_price, :decimal
  end
end
