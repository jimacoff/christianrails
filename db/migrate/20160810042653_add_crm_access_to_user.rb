class AddCrmAccessToUser < ActiveRecord::Migration
  def change
    add_column :users, :crm_access, :boolean, default: false
  end
end
