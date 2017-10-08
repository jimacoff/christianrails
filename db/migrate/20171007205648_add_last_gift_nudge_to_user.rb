class AddLastGiftNudgeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_gift_nudge, :datetime
  end
end
