class AddSlugToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :store_products, :slug, :string
  end
end
