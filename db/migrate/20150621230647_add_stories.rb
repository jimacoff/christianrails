class AddStories < ActiveRecord::Migration
  def change
    create_table :woods_stories do |t|
      t.string :name
      t.integer :player_id
      t.string :description
      t.datetime :last_modified
      t.datetime :date_created
      t.string :cover_image
      t.integer :genre_id
      t.integer :audience_id
      t.integer :status_id
      t.integer :entry_tree
      t.integer :size
      t.float   :rating
      t.boolean :allow_images
      t.integer :collab_limit
      t.integer :total_plays
      t.boolean :corporate
      t.boolean :mature
      t.string  :corp_link

      t.timestamps
    end
  end
end
