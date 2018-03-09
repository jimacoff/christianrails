class AddLifetimeMembershipTable < ActiveRecord::Migration[5.0]
  def change
    create_table :store_lifetime_memberships do |t|
      t.integer  :user_id
      t.integer  :cost_cents

      t.timestamps null: false
    end
  end

end
