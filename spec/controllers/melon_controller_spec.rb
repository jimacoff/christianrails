require 'rails_helper'

RSpec.describe MelonController, type: :controller do

  render_views

  let(:valid_session) { {} }

  describe "GET #index" do
    it "allows access" do
      get :index, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

end
