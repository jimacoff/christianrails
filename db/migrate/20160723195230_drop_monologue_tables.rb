class DropMonologueTables < ActiveRecord::Migration
  def change
    drop_table :monologue_posts    if table_exists? :monologue_posts
    drop_table :monologue_taggings if table_exists? :monologue_taggings
    drop_table :monologue_tags     if table_exists? :monologue_tags
    drop_table :monologue_users    if table_exists? :monologue_users
  end
end
