class AddIdeasTable < ActiveRecord::Migration
  def change
    create_table :crm_ideas do |t|

      t.integer :assistant_id
      t.string :name
      t.integer :status_id, default: 0
      t.datetime :completed_on

      t.timestamps null: false
    end
  end
end
