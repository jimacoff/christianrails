class MigrateColoursForCompatibility < ActiveRecord::Migration
  def change
    Woods::Palette.all.each do |p|
      p.fore_colour = p.fore_colour[1..6]
      p.back_colour = p.back_colour[1..6]
      p.alt_colour  = p.alt_colour[1..6]
      p.save
    end
  end
end
