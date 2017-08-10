class ChangePurchaseToDigitalPurchase < ActiveRecord::Migration[5.0]
  def change
    rename_table :store_purchases, :store_digital_purchases
  end
end
