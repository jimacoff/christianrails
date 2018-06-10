class AddMelonObject < ActiveRecord::Migration[5.0]
  def change
    create_table :melons do |t|
      t.integer :type_id

      t.timestamps null: false
    end
  end
end
