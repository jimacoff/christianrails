class AddItemDownloadsAndSomeOtherStuff < ActiveRecord::Migration
  def change
    create_table :woods_item_downloads do |t|
      t.references :woods_item, index: true, foreign_key: true
      t.references :woods_player, index: true, foreign_key: true

      t.timestamps null: false
    end

    # remove cover_image from story cuz we goin off the title now
    remove_column :woods_stories, :cover_image, :string if column_exists? :woods_stories, :cover_image
  end
end
