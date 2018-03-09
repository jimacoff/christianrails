class RemoveNotNullConstraintFromProduct < ActiveRecord::Migration[5.0]
  def change
    change_column :store_staged_purchases, :product_id, :integer, null: true
  end
end
