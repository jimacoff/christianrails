class AddPossibleitems < ActiveRecord::Migration
  def change
    create_table :woods_possibleitems do |t|
      t.boolean :enabled
      t.boolean :perpetual
      t.integer :itemset_id
      t.integer :node_id
      t.integer :story_id  # TODO DROP

      t.timestamps
    end
  end
end
