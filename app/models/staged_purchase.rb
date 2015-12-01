class StagedPurchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  validates_presence_of :user, :product

  def self.gross_cart_value_for(user_id)
    total = 0
    StagedPurchase.includes(:product).where(user_id: user_id).each do |sp|
      total += sp.product.price
    end
    total
  end

end
