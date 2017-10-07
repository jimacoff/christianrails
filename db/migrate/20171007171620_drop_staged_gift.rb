class DropStagedGift < ActiveRecord::Migration[5.0]
  def change
    drop_table :store_staged_gifts
  end
end
