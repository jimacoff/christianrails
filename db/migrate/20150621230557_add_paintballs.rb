class AddPaintballs < ActiveRecord::Migration
  def change
    create_table :woods_paintballs do |t|
      t.integer :node_id
      t.integer :palette_id
      t.boolean :enabled
      t.integer :story_id   # TODO DROP

      t.timestamps
    end
  end
end
