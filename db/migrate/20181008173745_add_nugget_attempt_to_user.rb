class AddNuggetAttemptToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nugget_attempts, :integer, default: 0
  end
end
