class AddPhysicalityToReleases < ActiveRecord::Migration
  def change
    add_column :releases, :physical_code, :string
  end
end
