class FixLinkedTree < ActiveRecord::Migration
  def change
    rename_column :woods_treelinks, :linked_tree, :linked_tree_id
  end
end
