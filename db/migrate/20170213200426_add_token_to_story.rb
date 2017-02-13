class AddTokenToStory < ActiveRecord::Migration[5.0]
  def change
    add_column :woods_stories, :sync_token, :string
  end
end
