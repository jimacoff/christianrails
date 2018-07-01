require 'rails_helper'

RSpec.describe GraveyardController, type: :controller do

  render_views

  let(:valid_session) { {} }

  describe "GET #index" do
    it "allows access" do
      get :index, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #fractalfic" do
    it "allows access" do
      get :fractalfic, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #gray" do
    it "allows access" do
      get :gray, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #blackink" do
    it "allows access" do
      get :blackink, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #silverstock" do
    it "allows access" do
      get :silverstock, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #reserve" do
    it "allows access" do
      get :reserve, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

end
