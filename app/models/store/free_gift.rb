class Store::FreeGift < ApplicationRecord
  belongs_to :recipient, class_name: "::User", foreign_key: "recipient_id", optional: true
  belongs_to :giver,     class_name: "::User", foreign_key: "giver_id",     optional: true
  belongs_to :product,   inverse_of: :free_gifts

  validates_presence_of :origin
  validate :has_either_giver_or_recipient

  def given?
    !!recipient
  end

  private

    def has_either_giver_or_recipient
      if !recipient && !giver
        errors.add(:giver_id, "This Free Gift requires either a giver or a recipient.")
      end
    end

end
