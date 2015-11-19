require 'rails_helper'

RSpec.describe DownloadsController, type: :controller do

  render_views

  before (:each) do
    @user = User.create!({
      username: 'testuser', 
      full_name: 'Test User',
      email: 'user@test.com',
      password: '12345678',
      password_confirmation: '12345678',
      country: 'CA'
    })
    sign_in @user
  end
  
  let(:user)    { FactoryGirl.create(:user) }
  let(:release) { FactoryGirl.create(:release) }

  let(:valid_attributes) {
    {
      user_id: user.id,
      release_id: release.id
    }
  }

  let(:invalid_attributes) {
    {
      user_id: -5,
      cat_id: 999
    }
  }

  let(:valid_session) { {} }

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Download" do
        expect {
          post :create, {:download => valid_attributes}, valid_session
        }.to change(Download, :count).by(1)
      end

      it "assigns a newly created download as @download" do
        post :create, {:download => valid_attributes}, valid_session
        expect(assigns(:download)).to be_a(Download)
        expect(assigns(:download)).to be_persisted
      end

      it "redirects to the home page" do
        post :create, {:download => valid_attributes}, valid_session
        expect(response).to redirect_to(store_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved download as @download" do
        post :create, {:download => invalid_attributes}, valid_session
        expect(assigns(:download)).to be_a_new(Download)
      end
    end
  end
  
end
