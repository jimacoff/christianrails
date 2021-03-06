require 'rails_helper'

RSpec.describe StoreHelper, type: :helper do

  describe "nudge_users_about_unsent_gifts?" do

    let(:user)      { FactoryBot.create(:user) }
    let(:product)   { FactoryBot.create(:product, title: "Flarn book") }
    let(:free_gift) { FactoryBot.create(:free_gift, product: product, giver: user) }

    it "nudges a user about unsent gifts if they consent to receive them" do
      ActionMailer::Base.deliveries = []
      free_gift.created_at = DateTime.current - 2.weeks
      free_gift.save
      user.send_me_emails = true
      user.save

      nudge_users_about_unsent_gifts
      user.reload

      expect( user.last_gift_nudge ).to_not be_nil
      expect( ActionMailer::Base.deliveries.size ).to eq(1)
    end

    it "does NOT nudge a user about unsent gifts if they don't want to receive emails" do
      ActionMailer::Base.deliveries = []
      free_gift.created_at = DateTime.current - 2.weeks
      free_gift.save

      nudge_users_about_unsent_gifts
      user.reload

      expect( user.last_gift_nudge ).to be_nil
      expect( ActionMailer::Base.deliveries.size ).to eq(0)
    end

    it "doesn't nudge anyone if none required" do
      ActionMailer::Base.deliveries = []
      free_gift.created_at = DateTime.current - 3.days
      free_gift.save

      nudge_users_about_unsent_gifts
      user.reload

      expect( user.last_gift_nudge ).to be_nil
      expect( ActionMailer::Base.deliveries.size ).to eq(0)
    end

  end

end
