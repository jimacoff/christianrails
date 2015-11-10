require 'rails_helper'

RSpec.describe DownloadsController, type: :controller do

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all downloads as @downloads" do
      download = Download.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:downloads)).to eq([download])
    end
  end

  describe "GET #show" do
    it "assigns the requested download as @download" do
      download = Download.create! valid_attributes
      get :show, {:id => download.to_param}, valid_session
      expect(assigns(:download)).to eq(download)
    end
  end

  describe "GET #new" do
    it "assigns a new download as @download" do
      get :new, {}, valid_session
      expect(assigns(:download)).to be_a_new(Download)
    end
  end

  describe "GET #edit" do
    it "assigns the requested download as @download" do
      download = Download.create! valid_attributes
      get :edit, {:id => download.to_param}, valid_session
      expect(assigns(:download)).to eq(download)
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

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested download" do
        download = Download.create! valid_attributes
        put :update, {:id => download.to_param, :download => new_attributes}, valid_session
        download.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested download as @download" do
        download = Download.create! valid_attributes
        put :update, {:id => download.to_param, :download => valid_attributes}, valid_session
        expect(assigns(:download)).to eq(download)
      end

      it "redirects to the download" do
        download = Download.create! valid_attributes
        put :update, {:id => download.to_param, :download => valid_attributes}, valid_session
        expect(response).to redirect_to(download)
      end
    end

    context "with invalid params" do
      it "assigns the download as @download" do
        download = Download.create! valid_attributes
        put :update, {:id => download.to_param, :download => invalid_attributes}, valid_session
        expect(assigns(:download)).to eq(download)
      end

      it "re-renders the 'edit' template" do
        download = Download.create! valid_attributes
        put :update, {:id => download.to_param, :download => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested download" do
      download = Download.create! valid_attributes
      expect {
        delete :destroy, {:id => download.to_param}, valid_session
      }.to change(Download, :count).by(-1)
    end

    it "redirects to the downloads list" do
      download = Download.create! valid_attributes
      delete :destroy, {:id => download.to_param}, valid_session
      expect(response).to redirect_to(downloads_url)
    end
  end

end
