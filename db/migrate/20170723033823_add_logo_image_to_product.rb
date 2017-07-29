class AddLogoImageToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :store_products, :logo_image, :string
  end
end
