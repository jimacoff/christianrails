class Store::PurchasedGift < ApplicationRecord
  belongs_to :user,    inverse_of: :purchased_gifts
  belongs_to :product, inverse_of: :purchased_gifts
  belongs_to :order,   inverse_of: :purchased_gifts


end
