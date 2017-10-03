class FixGiftUserIds < ActiveRecord::Migration[5.0]
  def change
    # idiot
    remove_column :store_free_gifts, :recipient_id, :integer
    rename_column :store_free_gifts, :giver_id, :recipient_id
    add_column    :store_free_gifts, :giver_id, :integer
  end
end
