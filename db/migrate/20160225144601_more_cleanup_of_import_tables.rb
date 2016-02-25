class MoreCleanupOfImportTables < ActiveRecord::Migration
  def change
    remove_column :woods_boxes, :name, :string

    remove_column :woods_treelinks, :story_id, :integer

    add_column :woods_players, :user_id, :integer

    rename_column :woods_treelinks, :storytree_id, :linked_tree
  end
end
