class Store::StagedGift < ApplicationRecord
  belongs_to :user
  belongs_to :product

  def self.gross_cart_value_for(user_id)
    total = 0
    Store::StagedGift.includes(:product).where( user_id: user_id ).each do |sg|
      total += sg.product.price
    end
    total
  end

end
