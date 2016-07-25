class SplitOutUserNames < ActiveRecord::Migration
  def change
    rename_column :users, :full_name, :first_name
    add_column    :users, :last_name, :string, default: ""
  end
end
