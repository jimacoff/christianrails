class AddPhysicalPurchasesAndVarietyPacks < ActiveRecord::Migration[5.0]
  def change

    create_table :store_variety_packs do |t|
      t.string  :name
      t.integer :price_cents
      t.string  :image_slug

      t.timestamps null: false
    end

    create_table :store_products_variety_packs, id: false do |t|
      t.integer :variety_pack_id
      t.integer :product_id
    end

    create_table :store_physical_purchases do |t|
      t.integer  :product_id
      t.integer  :variety_pack_id
      t.integer  :order_id
      t.integer  :price_cents
      t.integer  :quantity
      t.integer  :type_id,    default: 2

      t.timestamps null: false
    end

  end

end
