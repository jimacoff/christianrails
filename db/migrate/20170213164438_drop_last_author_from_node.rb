class DropLastAuthorFromNode < ActiveRecord::Migration[5.0]
  def change
    remove_column :woods_nodes, :last_author
  end
end
