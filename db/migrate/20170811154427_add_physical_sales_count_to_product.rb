class AddPhysicalSalesCountToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :store_products, :physical_sales, :integer, default: 0
  end
end
