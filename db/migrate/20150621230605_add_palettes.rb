class AddPalettes < ActiveRecord::Migration
  def change
    create_table :woods_palettes do |t|
      t.string :name
      t.integer :player_id
      t.string :fore_colour
      t.string :back_colour
      t.string :alt_colour

      t.timestamps
    end
  end
end
