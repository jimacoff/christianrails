class StillMoreFixesToImportSchema < ActiveRecord::Migration
  def change
    remove_column :woods_boxes, :name, :string if column_exists? :woods_boxes, :name

    rename_column :woods_storytrees, :max_tree_level, :max_level if column_exists? :woods_storytrees, :max_tree_level
    rename_column :woods_storytrees, :tree_max_level, :max_level if column_exists? :woods_storytrees, :tree_max_level

    # set default vals

    change_column :woods_boxes, :enabled, :boolean, default: true

    change_column :woods_items, :value, :integer, default: 1

    change_column :woods_paintballs, :enabled, :boolean, default: true

    change_column :woods_palettes, :fore_colour, :string, default: Woods::Palette::BLACK
    change_column :woods_palettes, :alt_colour,  :string, default: Woods::Palette::WHITE
    change_column :woods_palettes, :back_colour, :string, default: Woods::Palette::WHITE

    change_column :woods_players, :silver_coins, :integer, default: 0
    change_column :woods_players, :gold_coins, :integer, default: 0
    change_column :woods_players, :karma, :integer, default: 0
    change_column :woods_players, :total_equity, :integer, default: 0

    change_column :woods_possibleitems, :enabled, :boolean, default: true
    change_column :woods_possibleitems, :perpetual, :boolean, default: false

    change_column :woods_scorecards, :number_of_plays, :integer, default: 0
    change_column :woods_scorecards, :total_score, :integer, default: 0

    change_column :woods_stories, :published, :boolean, default: false

    change_column :woods_storytrees, :deletable, :boolean, default: false
    change_column :woods_storytrees, :max_level, :integer, default: 1

    change_column :woods_treelinks, :enabled, :boolean, default: true
  end
end
