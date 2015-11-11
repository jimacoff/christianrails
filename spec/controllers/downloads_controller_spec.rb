require 'rails_helper'

RSpec.describe DownloadsController, type: :controller do

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

  describe "GET #index" do
    it "assigns all downloads as @downloads" do
      download = Download.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:downloads)).to eq([download])
    end
  end

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

      it "redirects to the created download" do
        post :create, {:download => valid_attributes}, valid_session
        expect(response).to redirect_to(Download.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved download as @download" do
        post :create, {:download => invalid_attributes}, valid_session
        expect(assigns(:download)).to be_a_new(Download)
      end

      it "re-renders the 'new' template" do
        post :create, {:download => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end
  
end
