class AddTreeLinks < ActiveRecord::Migration
  def change
    create_table :woods_treelinks do |t|
      t.integer :node_id
      t.boolean :enabled
      t.integer :storytree_id
      t.integer :story_id

      t.timestamps
    end
  end
end
