class CreatedAndUpdatedEverywhere < ActiveRecord::Migration
  def change
    tablz = [:woods_boxes, :woods_finds, :woods_footprints, :woods_items, :woods_itemsets,
             :woods_nodes, :woods_paintballs, :woods_palettes, :woods_players, :woods_possibleitems,
             :woods_scorecards, :woods_stories, :woods_storytrees, :woods_treelinks]

    tablz.each do |tabl|
      change_table(tabl) { |x| x.timestamps }
    end

  end
end
