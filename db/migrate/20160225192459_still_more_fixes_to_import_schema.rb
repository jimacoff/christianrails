class StillMoreFixesToImportSchema < ActiveRecord::Migration
  def change
    remove_column :woods_boxes, :name, :string
  end
end
