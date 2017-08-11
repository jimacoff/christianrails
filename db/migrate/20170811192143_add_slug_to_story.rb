class AddSlugToStory < ActiveRecord::Migration[5.0]
  def change
    add_column :woods_stories, :slug, :string, default: ""
  end
end
