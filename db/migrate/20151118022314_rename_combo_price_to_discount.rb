class RenameComboPriceToDiscount < ActiveRecord::Migration
  def change
    rename_column :price_combos, :price, :discount
  end
end
