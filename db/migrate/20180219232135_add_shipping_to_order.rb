class AddShippingToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :store_orders, :shipping_cost_cents, :integer, default: 0
  end
end
