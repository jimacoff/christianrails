require 'rails_helper'

RSpec.describe NuggetsController, type: :controller do

  render_views

  let(:user) { FactoryBot.create(:user) }

  let(:valid_session) { {} }

  before (:each) do
    sign_in user
  end

  describe "GET #index" do
    it "allows access" do
      get :index, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "POST #unlock" do

    let!(:nugget) { FactoryBot.create(:nugget, access_code: "korg", unlocked_by: nil, unlocked_at: nil) }

    it "unlocks a nugget with a valid code" do
      post :unlock, params: {access_code: "korg"}, session: valid_session
      nugget.reload

      expect( nugget.unlocked_by ).to eq( user )
      expect( nugget.unlocked_at ).to_not be_nil
    end

    it "does NOT unlock a nugget with an invalid code" do
      post :unlock, params: {access_code: "sproooos"}, session: valid_session
      nugget.reload

      expect( nugget.unlocked_by ).to be_nil
      expect( nugget.unlocked_at ).to be_nil
    end

    it "does NOT unlock a nugget if you're not logged in" do
      sign_out user

      post :unlock, params: {access_code: "korg"}, session: valid_session
      nugget.reload

      expect( nugget.unlocked_by ).to be_nil
      expect( nugget.unlocked_at ).to be_nil
    end

  end

end
