class AddStoreFreeGifts < ActiveRecord::Migration[5.0]
  def change
    create_table :store_free_gifts do |t|
      t.integer :product_id
      t.integer :user_id
      t.string  :origin

      t.timestamps null: false
    end
  end
end
