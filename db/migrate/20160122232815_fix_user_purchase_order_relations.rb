class FixUserPurchaseOrderRelations < ActiveRecord::Migration
  def change
    add_column :orders, :user_id, :integer

    Purchase.all.each do |purchase|
      purchase.order.user_id = purchase.user_id
      purchase.order.save!
    end

    remove_column :purchases, :user_id

  end
end
