class AddFilenameToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :store_products, :filename, :string
  end
end
