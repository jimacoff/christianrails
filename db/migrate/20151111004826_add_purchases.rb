class AddPurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :product_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
