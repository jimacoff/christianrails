class AddLastCheckedToWatchProperty < ActiveRecord::Migration
  def change
    add_column :watch_properties, :last_checked, :datetime
  end
end
