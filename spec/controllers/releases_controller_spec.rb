require 'rails_helper'

RSpec.describe ReleasesController, type: :controller do

  render_views

  let(:product)   { FactoryGirl.create(:product) }

  let(:valid_attributes) {
    {
      product_id: product.id,
      format: "ePub",
      release_date: 3.days.ago,
      size: 2.4,
      version: "Second edition"
    }
  }

  let(:invalid_attributes) {
    {
      product_id: product.id,
      something_bad: "This",
      bad_attr: 993
    }
  }

  let(:valid_session) { {} }

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
        expect(response).to redirect_to(product_path(product.id))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved release as @release" do
        post :create, {:release => invalid_attributes}, valid_session
        expect(assigns(:release)).to be_a_new(Release)
      end

      it "re-renders the 'new' template" do
        post :create, {:release => invalid_attributes}, valid_session
        expect(response).to redirect_to(product_path(product.id))
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      
      let(:new_product) { FactoryGirl.create(:product) }
      let(:new_attributes) {
        {
          product_id: new_product.id,
          format: "PDF",
          release_date: '2015-11-06 16:42:29.000000000 -0500',
          size: 1.2,
          version: "Third edition"
        }
      }

      it "updates the requested release" do
        release = Release.create! valid_attributes
        put :update, {:id => release.to_param, :release => new_attributes}, valid_session
        release.reload
        
        expect( release.product.id ).to eq(new_product.id)
        expect( release.format ).to eq("PDF")
        expect( release.release_date ).to eq('2015-11-06 16:42:29.000000000 -0500')
        expect( release.size ).to eq(1.2)
        expect( release.version ).to eq("Third edition")
      end

      it "assigns the requested release as @release" do
        release = Release.create! valid_attributes
        put :update, {:id => release.to_param, :release => valid_attributes}, valid_session
        expect(assigns(:release)).to eq(release)
      end

      it "redirects to the product of the release" do
        release = Release.create! valid_attributes
        put :update, {:id => release.to_param, :release => valid_attributes}, valid_session
        expect(response).to redirect_to(product_path(release.product_id))
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
