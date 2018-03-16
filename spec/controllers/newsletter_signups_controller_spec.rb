require 'rails_helper'

RSpec.describe NewsletterSignupsController, type: :controller do

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
    @user.save
  end

  let(:valid_attributes) {
    {
      email: "lol@email.com"
    }
  }

  let(:invalid_attributes) {
    {
      email: "dsfsdfsd"
    }
  }

  let(:valid_session) { {} }

  describe "POST #create" do

    context "with valid params" do
      it "creates a new NewsletterSignup" do
        expect {
          post :create, params: { newsletter_signup: valid_attributes }, session: valid_session
        }.to change( NewsletterSignup, :count ).by(1)

        newsletter_signup = NewsletterSignup.take
        expect( newsletter_signup.email ).to eq("lol@email.com")
      end
    end

    context "with invalid params" do
      it "errors out" do
        post :create, params: { newsletter_signup: invalid_attributes }, session: valid_session
        expect( response ).to be_unprocessable
      end
    end

  end

end
