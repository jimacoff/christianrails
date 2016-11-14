class MovePhysicalBookPriceToObject < ActiveRecord::Migration
  def change
    add_column :products, :physical_price, :integer, default: 20
  end
end
