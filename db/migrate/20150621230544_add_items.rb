class AddItems < ActiveRecord::Migration
  def change
    create_table :woods_items do |t|
    t.string :name
    t.integer :value
    t.string :legend, limit: 1500
    t.string :image
    t.integer :itemset_id
    t.string :thumb    # TODO DROP

    t.timestamps
  end
  end
end
