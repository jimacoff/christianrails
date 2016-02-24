class AddBoxes < ActiveRecord::Migration
  def change
    create_table :woods_boxes do |t|
      t.string :name
      t.integer :itemset_id
      t.boolean :enabled
      t.integer :story_id  # TODO drop later
      t.integer :node_id

      t.timestamps
    end
  end
end
