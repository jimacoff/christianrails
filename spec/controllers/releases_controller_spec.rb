require 'rails_helper'

RSpec.describe ReleasesController, type: :controller do

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all releases as @releases" do
      release = Release.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:releases)).to eq([release])
    end
  end

  describe "GET #show" do
    it "assigns the requested release as @release" do
      release = Release.create! valid_attributes
      get :show, {:id => release.to_param}, valid_session
      expect(assigns(:release)).to eq(release)
    end
  end

  describe "GET #new" do
    it "assigns a new release as @release" do
      get :new, {}, valid_session
      expect(assigns(:release)).to be_a_new(Release)
    end
  end

  describe "GET #edit" do
    it "assigns the requested release as @release" do
      release = Release.create! valid_attributes
      get :edit, {:id => release.to_param}, valid_session
      expect(assigns(:release)).to eq(release)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Release" do
        expect {
          post :create, {:release => valid_attributes}, valid_session
        }.to change(Release, :count).by(1)
      end

      it "assigns a newly created release as @release" do
        post :create, {:release => valid_attributes}, valid_session
        expect(assigns(:release)).to be_a(Release)
        expect(assigns(:release)).to be_persisted
      end

      it "redirects to the created release" do
        post :create, {:release => valid_attributes}, valid_session
        expect(response).to redirect_to(Release.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved release as @release" do
        post :create, {:release => invalid_attributes}, valid_session
        expect(assigns(:release)).to be_a_new(Release)
      end

      it "re-renders the 'new' template" do
        post :create, {:release => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested release" do
        release = Release.create! valid_attributes
        put :update, {:id => release.to_param, :release => new_attributes}, valid_session
        release.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested release as @release" do
        release = Release.create! valid_attributes
        put :update, {:id => release.to_param, :release => valid_attributes}, valid_session
        expect(assigns(:release)).to eq(release)
      end

      it "redirects to the release" do
        release = Release.create! valid_attributes
        put :update, {:id => release.to_param, :release => valid_attributes}, valid_session
        expect(response).to redirect_to(release)
      end
    end

    context "with invalid params" do
      it "assigns the release as @release" do
        release = Release.create! valid_attributes
        put :update, {:id => release.to_param, :release => invalid_attributes}, valid_session
        expect(assigns(:release)).to eq(release)
      end

      it "re-renders the 'edit' template" do
        release = Release.create! valid_attributes
        put :update, {:id => release.to_param, :release => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested release" do
      release = Release.create! valid_attributes
      expect {
        delete :destroy, {:id => release.to_param}, valid_session
      }.to change(Release, :count).by(-1)
    end

    it "redirects to the releases list" do
      release = Release.create! valid_attributes
      delete :destroy, {:id => release.to_param}, valid_session
      expect(response).to redirect_to(releases_url)
    end
  end

end
