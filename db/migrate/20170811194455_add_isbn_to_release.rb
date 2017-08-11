class AddIsbnToRelease < ActiveRecord::Migration[5.0]
  def change
    add_column :store_releases, :isbn, :string, default: ""
  end
end
