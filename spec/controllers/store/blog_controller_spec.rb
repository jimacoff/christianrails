require 'rails_helper'

RSpec.describe Store::BlogController, type: :controller do

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
    it "allows access" do
      get :show_post, params: {post: "20180224_new_stuff_in_the_works" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20171211_holiday_sale" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20171105_november_news" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20171006_important_quail_bulletin" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20170926_snapback_shimari_released" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20170805_snapback_for_free" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20170729_webstore_upgrade" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20170716_on_writing_novellas" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20170402_a_dream_of_spring" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20161201_a_snapback_review" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20161113_snapback_released" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20161022_snapback_to_the_printers" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20160909_word_on_the_street" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20160816_tie_in_for_ghostcrime" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20160808_between_contracts" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20160618_new_book_in_the_works" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20160522_ghostcrime_2ed_printed" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20160501_spring_cleaning" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20160411_christian_at_geequinox" }, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #category" do
    it "allows access" do
      get :category, params: {name: "Something dumb that I do"}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #tag" do
    it "allows access" do
      get :tag, params: {name: "writing"}, session: valid_session
      expect( response ).to be_ok
    end
  end
end
