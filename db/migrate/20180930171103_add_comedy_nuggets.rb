class AddComedyNuggets < ActiveRecord::Migration[5.0]
  def change
    create_table :nuggets do |t|
      t.integer  :serial_number
      t.string   :joke, limit: 76
      t.string   :access_code
      t.boolean  :disbursed, default: false
      t.integer  :unlocked_by_id
      t.datetime :unlocked_at

      t.timestamps null: false
    end
  end
end
