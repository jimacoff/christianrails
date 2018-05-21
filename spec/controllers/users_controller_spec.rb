require 'rails_helper'

RSpec.describe UsersController, type: :controller do

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

  describe "GET #show" do

    let(:different_user) { FactoryBot.create(:user) }

    it "shows a user's profile page" do
      get :show, params: {id: @user.to_param}, session: valid_session
      expect( response ).to be_ok
    end

    it "shows a different user's profile page" do
      get :show, params: {id: different_user.to_param}, session: valid_session
      expect( response ).to be_ok
    end

  end

  describe "#consume" do

    it "requires a user to be logged in" do
      sign_out @user

      post :consume, params: {product: 'thisbadger'}, session: valid_session
      expect( response ).to be_unauthorized
    end

    context "POST create" do

      it "creates a record that the user has consumed a valid product" do
        post :consume, params: {product: "thisbadger"}, session: valid_session
        expect( response ).to be_created
      end

      it "does NOT create a record for an invalid product" do
        post :consume, params: {product: "flarn"}, session: valid_session
        expect( response ).to be_unprocessable
      end

    end

    context "DELETE destroy" do

      it "removes an existing record from a user" do
        delete :consume, params: {product: "thisbadger"}, session: valid_session
        expect( response ).to be_ok
      end

      it "does not change a record if an invalid product is given" do
        delete :consume, params: {product: "clorb"}, session: valid_session
        expect( response ).to be_unprocessable
      end

    end

  end

end
