class ChangeSomeDefaults < ActiveRecord::Migration
  def change
    change_column :woods_scorecards, :number_of_plays, :integer, default: 1

    change_column :woods_players, :story_limit, :integer, default: 10
    change_column :woods_players, :item_limit, :integer, default: 100
    change_column :woods_players, :palette_limit, :integer, default: 100

  end
end
