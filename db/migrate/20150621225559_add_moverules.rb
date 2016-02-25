class AddMoverules < ActiveRecord::Migration
  def change
    create_table :woods_moverules do |t|
      t.string :name

      t.timestamps
    end
  end
end
