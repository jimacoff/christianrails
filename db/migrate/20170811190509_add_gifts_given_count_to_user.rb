class AddGiftsGivenCountToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :books_given, :integer, default: 0
  end
end
