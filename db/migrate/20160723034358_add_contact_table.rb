class AddContactTable < ActiveRecord::Migration
  def change
    create_table :crm_contacts do |t|
      t.string   :firstname
      t.string   :lastname
      t.string   :business
      t.string   :positiontitle
      t.string   :source
      t.string   :email
      t.string   :phone
      t.string   :address
      t.integer  :assistant_id

      t.timestamps null: false
    end
  end
end
