class UpgradeFreeGifts < ActiveRecord::Migration[5.0]
  def change
    add_column    :store_free_gifts, :recipient_id, :integer
    rename_column :store_free_gifts, :user_id, :giver_id

    drop_table :store_purchased_gifts
  end
end
