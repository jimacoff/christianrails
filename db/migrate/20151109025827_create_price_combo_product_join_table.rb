class CreatePriceComboProductJoinTable < ActiveRecord::Migration
  def change
    create_table :price_combos_products, id: false do |t|
      t.integer :price_combo_id
      t.integer :product_id
    end
  end
end
