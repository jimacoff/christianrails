class AddPopularityImageFieldToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :store_products, :popularity_image, :string
  end
end
