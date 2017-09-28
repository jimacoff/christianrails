class ChangeWinningConditionFlagToInt < ActiveRecord::Migration[5.0]
  def change
    remove_column :woods_items, :winning_condition, :boolean
    add_column :woods_items, :winning_condition, :integer, default: 0
  end
end
