class AddBlockedAtToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :blocked_at, :datetime, default: nil
  end
end
