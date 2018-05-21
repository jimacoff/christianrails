class AddIndexForHstoreField < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :progress_list, using: :gin
  end
end
