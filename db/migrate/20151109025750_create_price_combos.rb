class CreatePriceCombos < ActiveRecord::Migration
  def change
    create_table :price_combos do |t|
      t.string :name
      t.decimal :price

      t.timestamps null: false
    end
  end
end
