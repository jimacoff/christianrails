require 'rails_helper'

RSpec.describe ComputersController, type: :controller do

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
    it "should allow access" do
      get :index, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #archives" do
    it "should allow access" do
      get :archives, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #show_post" do
    it "should allow access" do
      get :show_post, params: {post: "20170527_git_for_authors" }, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #category" do
    it "should allow access" do
      get :category, params: {name: "data"}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #tag" do
    it "should allow access" do
      get :tag, params: {name: "computers"}, session: valid_session
      expect( response ).to be_ok
    end
  end
end
