class ConvertPhysicalPriceToCents < ActiveRecord::Migration[5.0]
  def change
    add_column :store_products, :physical_price_cents, :integer, default: 0

    Store::Product.all.each do |p|
      p.physical_price_cents = p.physical_price * 100
      p.save
    end

    remove_column :store_products, :physical_price
  end
end
