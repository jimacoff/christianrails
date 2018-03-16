require 'rails_helper'

RSpec.describe PoliciesController, type: :controller do

  render_views

  let(:valid_session) { {} }

  describe "GET #terms_of_use" do
    it "allows access" do
      get :terms_of_use, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #privacy" do
    it "allows access" do
      get :privacy, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #customer_service" do
    it "allows access" do
      get :customer_service, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #refund" do
    it "allows access" do
      get :refund, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

end
