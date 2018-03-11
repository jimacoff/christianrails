class AddOrderIdToLifetimeMemberships < ActiveRecord::Migration[5.0]
  def change
    add_column :store_lifetime_memberships, :order_id, :integer
  end
end
