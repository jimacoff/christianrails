class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.references :product, index: true, foreign_key: true
      t.string :format
      t.datetime :release_date
      t.decimal :size
      t.string :version

      t.timestamps null: false
    end
  end
end
