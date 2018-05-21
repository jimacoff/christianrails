class AddReadListToUser < ActiveRecord::Migration[5.0]
  def change
    execute 'CREATE EXTENSION IF NOT EXISTS hstore;'
    enable_extension "hstore"

    add_column :users, :progress_list, :hstore, default: nil
  end
end
