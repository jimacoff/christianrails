class GetRidOfMoverules < ActiveRecord::Migration
  def change
    drop_table :woods_moverules if table_exists? :woods_moverules
  end
end
