class AllowCrmByDefault < ActiveRecord::Migration
  def change
    change_column :users, :crm_access, :boolean,  default: true
    User.all.each do |u|
      u.crm_access = true
      u.save
    end
  end
end
