class Store::FreeGift < ApplicationRecord
  belongs_to :user,    inverse_of: :free_gifts
  belongs_to :product, inverse_of: :free_gifts

  validates_presence_of :origin
end
