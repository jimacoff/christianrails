class ChangeShortDescToTextType < ActiveRecord::Migration[5.0]
  def change
    change_column :store_products, :short_desc, :text
  end
end
