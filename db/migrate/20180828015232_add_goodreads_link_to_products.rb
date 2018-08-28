class AddGoodreadsLinkToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :store_products, :goodreads_link, :string, default: nil
  end
end
