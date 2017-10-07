class AddTypeToDigitalPurchase < ActiveRecord::Migration[5.0]
  def change
    add_column :store_digital_purchases, :type_id, :integer, default: 0
  end
end
