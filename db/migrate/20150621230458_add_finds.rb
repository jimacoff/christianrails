class AddFinds < ActiveRecord::Migration
  def change
    create_table :woods_finds do |t|
    t.integer :player_id
    t.integer :item_id
    t.integer :story_id
    t.datetime :find_time

    t.timestamps
  end
end
end
