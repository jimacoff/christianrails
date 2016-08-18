class AddMailOutData < ActiveRecord::Migration
  def change
    create_table :crm_mailouts do |t|

      t.integer :assistant_id
      t.string :type_id
      t.integer :status_id, default: 0

      t.timestamps null: false
    end

    add_column :crm_assistants, :email_me_daily, :boolean, default: false
  end
end
