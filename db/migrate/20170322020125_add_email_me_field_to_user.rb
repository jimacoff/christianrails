class AddEmailMeFieldToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :send_me_emails, :boolean, default: false
  end
end
