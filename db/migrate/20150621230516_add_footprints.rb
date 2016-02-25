class AddFootprints < ActiveRecord::Migration
  def change
    create_table :woods_footprints do |t|
    t.integer :scorecard_id
    t.integer :storytree_id
    t.string :footprint_data, limit: 2048

    t.timestamps
  end
  end
end
