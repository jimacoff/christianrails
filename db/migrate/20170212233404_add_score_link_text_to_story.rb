class AddScoreLinkTextToStory < ActiveRecord::Migration[5.0]
  def change
    add_column :woods_stories, :store_link_text, :string

    Woods::Story.all.each do |s|
      if s.name == "Diamond Find"
        s.store_link_text = "Download my diamonds!"
        s.save
      end
    end
  end
end
