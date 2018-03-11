class Store::LifetimeMembership < ApplicationRecord
  belongs_to :user, inverse_of: :lifetime_membership
  belongs_to :order

  validates_presence_of :cost_cents
  monetize :cost_cents

  CURRENT_PRICE_CENTS = 17_38   # this is foreshadowing
end
