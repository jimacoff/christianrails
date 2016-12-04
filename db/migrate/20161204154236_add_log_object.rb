class AddLogObject < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string  :description
      t.string  :location
      t.integer :type_id, default: 0
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
