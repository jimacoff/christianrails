class AddPriceSnapshotToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :price, :decimal
    add_column :orders, :tax, :decimal

    # fix the purchases
    Purchase.all.each do |purchase|
      purchase.price = purchase.product.price
      purchase.save
    end

  end
end
