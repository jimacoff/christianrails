class AddWinningConditionFlagToWoodsItem < ActiveRecord::Migration[5.0]
  def change
    add_column :woods_items, :winning_condition, :boolean, default: false
  end
end
