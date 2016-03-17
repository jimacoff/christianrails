class FixItemDownloadsAndAddLeftRights < ActiveRecord::Migration
  def change
    rename_column :woods_item_downloads, :woods_item_id,   :item_id
    rename_column :woods_item_downloads, :woods_player_id, :player_id

    add_column :woods_scorecards, :lefts,  :integer, default: 0
    add_column :woods_scorecards, :rights, :integer, default: 0
  end
end
