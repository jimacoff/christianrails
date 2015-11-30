class AddOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string   :payer_id
      t.string   :payment_id
      t.integer  :price_combo_id
      t.decimal  :total

      t.timestamps null: false
    end
    add_column :purchases, :order_id, :integer
  end
end
