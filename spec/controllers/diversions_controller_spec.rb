require 'rails_helper'

RSpec.describe DiversionsController, type: :controller do

  render_views

  let(:valid_session) { {} }

  describe "GET #index" do
    it "allows access" do
      get :index, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #rainfield" do
    it "allows access" do
      get :rainfield, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

end
