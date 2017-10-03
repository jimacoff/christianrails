class Store::FreeGift < ApplicationRecord
  belongs_to :recipient, class_name: "::User", foreign_key: "recipient_id", optional: true
  belongs_to :giver,     class_name: "::User", foreign_key: "giver_id"
  belongs_to :product, inverse_of: :free_gifts

  validates_presence_of :origin

  def given?
    !!recipient
  end

end
