require 'rails_helper'

RSpec.describe Crm::AssistantsController, type: :controller do

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

    it "renders a basic index" do
      get :index, params: {}, session: valid_session
      expect(response).to be_ok
    end
  end

end
