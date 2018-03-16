require 'rails_helper'

RSpec.describe AdminController, type: :controller do

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

  describe "GET #index" do

    it "does NOT allow access to non-admin user" do
      get :index, params: {}, session: valid_session
      expect(response).to redirect_to(root_path)
    end

    it "allows admins access" do
      @user.admin = true
      @user.save

      get :index, params: {}, session: valid_session
      expect(response).to be_ok
    end
  end

end
