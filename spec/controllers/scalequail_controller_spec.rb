require 'rails_helper'

RSpec.describe ScalequailController, type: :controller do

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
      get :show_post, params: {post: "let_me_tell_you_about_my_business"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "have_you_tried_not_scaling_your_business"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "the_pre_scale_checklist"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "scaling_time_has_come"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "business_algorithms_for_a_successful_scale"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "scaling_up_digital_sales_using_peoples_existing_friendships"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "cracking_the_physical_distribution_problem"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "overcharging_for_loyalty"}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #category" do
    it "should allow access" do
      get :category, params: {name: "scaling"}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #tag" do
    it "should allow access" do
      get :tag, params: {name: "business"}, session: valid_session
      expect( response ).to be_ok
    end
  end
end
