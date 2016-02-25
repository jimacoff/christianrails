class AddScorecards < ActiveRecord::Migration
  def change
    create_table :woods_scorecards do |t|
      t.integer :player_id
      t.integer :story_id
      t.integer :number_of_plays
      t.integer :total_score

      t.timestamps
    end
  end
end
