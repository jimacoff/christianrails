class AddInvitedForToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :invited_for_product_id, :integer
  end
end
