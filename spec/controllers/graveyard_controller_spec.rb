require 'rails_helper'

RSpec.describe GraveyardController, type: :controller do

  render_views

  let(:valid_session) { {} }

  describe "GET #fractalfic" do
    it "allows access" do
      get :fractalfic, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

end
