class AddDistributionsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :store_distributions do |t|
      t.integer :product_id
      t.integer :purchaser_id
      t.integer :quantity
      t.text    :message
      t.integer :status_id

      t.timestamps null: false
    end
  end
end
