require 'rails_helper'

RSpec.describe Store::SnapbackController, type: :controller do

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

  let!(:vol1) { FactoryGirl.create(:product, title: "Snapback: Fuseki") }
  let!(:vol2) { FactoryGirl.create(:product, title: "Snapback: Shimari") }

  describe "GET #fuseki" do
    it "should allow access" do
      get :fuseki, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #shimari" do
    it "should allow access" do
      get :shimari, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

end
