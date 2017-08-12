class AddStagedGiftObject < ActiveRecord::Migration[5.0]
  def change
    create_table :store_staged_gifts do |t|
      t.integer :product_id
      t.integer :user_id
      t.integer :quantity

      t.timestamps null: false
    end

    add_column :store_purchased_gifts, :purchased_by_id, :integer
  end
end
