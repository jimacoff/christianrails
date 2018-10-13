class ChangeEntryTreeId < ActiveRecord::Migration[5.0]
  def change
    rename_column :woods_stories, :entry_tree, :entry_tree_id
  end
end
