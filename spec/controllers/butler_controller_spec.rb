require 'rails_helper'

RSpec.describe ButlerController, type: :controller do

  render_views

  let(:valid_session) { {} }

  describe "GET #index" do
    it "should allow access" do
      get :index, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #show_post" do
    it "should allow access" do
      get :show_post, params: {post: "20160826_did_not_get_the_social_media_job" }, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20171231_another_year_to_evaluate"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20170415_unpopular_diamond_finds"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20170116_4_things_computer_world_got_right"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20161230_obligatory_2016_listicle"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20160826_did_not_get_the_social_media_job"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20160212_2015_in_review"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20151126_actually_did_publish_that_book"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20150822_new_book_forthcoming"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20150515_victoria_day_hacks"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20150311_go_is_great"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20141231_2014_in_review"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20141123_breaking_badger_news"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20140829_fractalfic_launched"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20140804_not_buying_enough"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20140628_press_to_impress"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20140429_lara_game_reviews"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20140208_bird_related_games"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20131231_2013_in_review"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20131216_animal_go_moves"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20131023_deer_hunter_2014"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20130815_grocery_shopping_tips"}, session: valid_session
      expect( response ).to be_ok
      get :show_post, params: {post: "20130725_i_hate_marketing_in_2013"}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #category" do
    it "should allow access" do
      get :category, params: {name: "comedy"}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #tag" do
    it "should allow access" do
      get :tag, params: {name: "birds"}, session: valid_session
      expect( response ).to be_ok
    end
  end
end
