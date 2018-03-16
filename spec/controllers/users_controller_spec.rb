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

end
