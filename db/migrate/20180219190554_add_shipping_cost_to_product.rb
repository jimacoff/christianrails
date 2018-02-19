class AddShippingCostToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :store_products, :shipping_cost_cents, :integer, default: 0

    add_column :users, :company, :string
    add_column :users, :purchaser, :boolean, default: false
  end
end
