require 'rails_helper'

RSpec.describe BadgerController, type: :controller do

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
    it "allows access" do
      get :index, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #archives" do
    it "allows access" do
      get :archives, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #show_post" do
    it "allows access to each post" do
      get :show_post, params: {post: "20160427_food_fight" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20160106_counter_attacks" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20150428_springtime" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20150329_badger_games" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20150226_leaks" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20150128_snow_problem" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20141222_housecoat" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20141126_strategies" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20141119_another_november" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20100204_blanket_statements" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20091127_november" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20091123_a_knock_at_the_door" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20091120_badger_for_business" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20091118_i_found_this_badger" }, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #tag" do
    it "allows access" do
      get :tag, params: {name: "cold"}, session: valid_session
      expect( response ).to be_ok
    end
  end
end
