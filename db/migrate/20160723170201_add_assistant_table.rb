class AddAssistantTable < ActiveRecord::Migration
  def change
    create_table :crm_assistants do |t|
      t.string   :name
      t.integer  :user_id
      t.integer  :personality_id

      t.timestamps null: false
    end
  end
end
