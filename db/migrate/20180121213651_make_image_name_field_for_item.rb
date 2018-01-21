class MakeImageNameFieldForItem < ActiveRecord::Migration[5.0]
  def change
    Woods::Item.all.each do |item|
      item.image = item.value.to_s
      item.save
    end
  end
end
