class AddPurchasedGiftsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :store_purchased_gifts do |t|
      t.integer :product_id
      t.integer :purchaser_id
      t.integer :recipient_id
      t.integer :order_id

      t.timestamps null: false
    end
  end
end
