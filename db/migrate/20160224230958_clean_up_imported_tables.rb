class CleanUpImportedTables < ActiveRecord::Migration
  def change
    remove_column :woods_boxes, :story_id, :integer

    remove_column :woods_finds, :find_time, :date_time

    remove_column :woods_itemsets, :public, :boolean

    remove_column :woods_items, :thumb, :string

    remove_column :woods_nodes, :image, :string

    remove_column :woods_paintballs, :story_id, :integer

    remove_column :woods_possibleitems, :story_id, :integer

    remove_column :woods_stories, :date_created, :datetime
    remove_column :woods_stories, :last_modified, :datetime
    remove_column :woods_stories, :genre_id, :integer
    remove_column :woods_stories, :audience_id, :integer
    remove_column :woods_stories, :status_id, :integer
    remove_column :woods_stories, :size, :integer
    remove_column :woods_stories, :rating, :float
    remove_column :woods_stories, :allow_images, :boolean
    remove_column :woods_stories, :collab_limit, :integer
    remove_column :woods_stories, :corporate, :boolean
    remove_column :woods_stories, :mature, :boolean
    remove_column :woods_stories, :corp_link, :string
    add_column    :woods_stories, :published, :boolean, default: false

    remove_column :woods_players, :name, :string
    remove_column :woods_players, :password, :string
    remove_column :woods_players, :session_id, :string
    remove_column :woods_players, :email, :string
    remove_column :woods_players, :joined, :string
    remove_column :woods_players, :weight, :string
    remove_column :woods_players, :membership_level, :string
    remove_column :woods_players, :last_login, :string
    remove_column :woods_players, :email_consent, :boolean
    remove_column :woods_players, :consent_to_email, :boolean

  end
end
