class AddMeetingsTable < ActiveRecord::Migration
  def change
    create_table :crm_meetings do |t|

      t.string :name
      t.integer :contact_id
      t.integer :assistant_id
      t.datetime :date_time
      t.integer :status_id, default: 0

      t.timestamps null: false
    end
  end
end
