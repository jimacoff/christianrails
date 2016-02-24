class AddNodes < ActiveRecord::Migration
  def change
    create_table :woods_nodes do |t|
        t.integer :moverule_id
        t.string :name
        t.string :left_text, limit: 30
        t.string :right_text, limit: 30
        t.integer :storytree_id
        t.integer :tree_index
        t.string :image    # TODO DROP
        t.string :main_text, limit: 1500

        t.integer :last_author   # TODO DROP

        t.timestamps
    end
  end
end
