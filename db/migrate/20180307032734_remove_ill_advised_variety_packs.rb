class RemoveIllAdvisedVarietyPacks < ActiveRecord::Migration[5.0]
  def change
    drop_table :store_variety_packs
    drop_table :store_products_variety_packs
    remove_column :store_physical_purchases, :variety_pack_id
  end
end
