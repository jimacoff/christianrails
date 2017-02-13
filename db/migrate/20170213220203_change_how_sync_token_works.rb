class ChangeHowSyncTokenWorks < ActiveRecord::Migration[5.0]
  def change
    remove_column :woods_stories, :sync_token, :string
    add_column  :woods_stories, :allow_remote_syncing, :boolean, default: false
  end
end
