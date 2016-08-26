class AddWatchPropertyTable < ActiveRecord::Migration
  def change
    create_table :watch_properties do |t|

      t.string :name
      t.string :url
      t.string :expected_response

      t.timestamps null: false
    end
  end
end
