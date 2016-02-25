class AddStoryTrees < ActiveRecord::Migration
  def change
    create_table :woods_storytrees do |t|
      t.string :name
      t.integer :max_tree_level
      t.integer :story_id
      t.boolean :deletable

      t.timestamps
    end
  end
end
