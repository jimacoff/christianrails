class AddItemsets < ActiveRecord::Migration
  def change
    create_table :woods_itemsets do |t|
    t.string :name
    t.integer :player_id
    t.boolean :public

    t.boolean

    t.timestamps
  end
  end
end
