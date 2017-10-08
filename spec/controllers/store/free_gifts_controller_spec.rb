require 'rails_helper'

RSpec.describe Store::FreeGiftsController, type: :controller do

  render_views

  before (:each) do
    @user = User.create!({
      username: 'testuser',
      first_name: 'Test',
      last_name: 'User',
      email: 'user@test.com',
      password: '12345678',
      password_confirmation: '12345678',
      country: 'CA'
    })
    sign_in @user
  end

  let(:valid_session) { {} }

  describe "POST #gift" do

    let(:free_gift) { FactoryGirl.create(:free_gift, giver: @user) }
    let!(:existing_user) { FactoryGirl.create(:user) }

    it "sends an email and gives a gift to a new user" do
      ActionMailer::Base.deliveries = []

      expect{
        post :give, params: {id: free_gift.to_param, email: 'flarnmail@test.com', first_name: "Flarn", last_name: "Clorb"}, session: valid_session
      }.to change(User, :count).by(1)
      expect( response ).to redirect_to library_path

      expect( ActionMailer::Base.deliveries.size ).to eq(1)
      free_gift.reload

      expect( free_gift.recipient_id ).to_not be_nil
    end

    it "sends an email and gives a gift to an existing user who doesn't own the product" do
      ActionMailer::Base.deliveries = []

      expect{
        post :give, params: {id: free_gift.to_param, email: existing_user.email, first_name: "Flarn", last_name: "Clorb"}, session: valid_session
      }.to change(User, :count).by(0)
      expect( response ).to redirect_to library_path

      expect( ActionMailer::Base.deliveries.size ).to eq(1)
      free_gift.reload

      expect( free_gift.recipient_id ).to_not be_nil
    end

    it "fails if not enough params are given" do
      ActionMailer::Base.deliveries = []

      post :give, params: {id: free_gift.to_param}, session: valid_session
      expect( response ).to redirect_to library_path

      expect( ActionMailer::Base.deliveries.size ).to eq(0)
    end

  end

end
