class AddFilenameToReleases < ActiveRecord::Migration
  def change
    add_column :releases, :file_name, :string
  end
end
