class MoveItemsAndPalettesToStory < ActiveRecord::Migration
  def change
    add_column :woods_itemsets, :story_id, :integer
    add_column :woods_palettes, :story_id, :integer

    Woods::Itemset.all.each do |i|
      i.story_id = 1
      i.save
    end

    Woods::Palette.all.each do |i|
      i.story_id = 1
      i.save
    end

    remove_column :woods_itemsets, :player_id, :integer
    remove_column :woods_palettes, :player_id, :integer
  end
end
