class AddSmallImageToProduct < ActiveRecord::Migration
  def change
    add_column :products, :small_image, :string
  end
end
