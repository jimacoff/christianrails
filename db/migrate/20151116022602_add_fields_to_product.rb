class AddFieldsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :rank, :integer
    add_column :products, :image, :string
  end
end
