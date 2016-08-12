class AddTasksTable < ActiveRecord::Migration
  def change
    create_table :crm_tasks do |t|

      t.integer :assistant_id
      t.string :name
      t.integer :type_id
      t.datetime :due_at
      t.integer :recurral_period
      t.integer :recurral_weekday
      t.integer :recurral_monthday
      t.integer :status_id, default: 0
      t.datetime :closed_at

      t.timestamps null: false
    end
  end
end
