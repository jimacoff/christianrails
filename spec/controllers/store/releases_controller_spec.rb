require 'rails_helper'

RSpec.describe Store::ReleasesController, type: :controller do

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
    @user.admin = true
    @user.save
  end

  let(:product) { FactoryGirl.create(:product) }

  let(:valid_attributes) {
    {
      format: "ePub",
      release_date: 3.days.ago,
      size: 2.4,
      version: "Second edition"
    }
  }

  let(:invalid_attributes) {
    {
      something_bad: "This",
      bad_attr: 993
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all releases for product as @releases" do
      release = product.releases.create! valid_attributes
      get :index, params: {product_id: product}, session: valid_session
      expect(assigns(:releases)).to eq([release])
    end
  end

  describe "GET #new" do
    it "assigns a new release as @release" do
      get :new, params: {product_id: product}, session: valid_session
      expect(assigns(:release)).to be_a_new(Store::Release)
    end
  end

  describe "GET #edit" do
    it "assigns the requested release as @release" do
      release = product.releases.create! valid_attributes
      get :edit, params: {product_id: product, id: release.to_param}, session: valid_session
      expect(assigns(:release)).to eq(release)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Release" do
        expect {
          post :create, params: {product_id: product, store_release: valid_attributes}, session: valid_session
        }.to change(Store::Release, :count).by(1)
      end

      it "assigns a newly created release as @release" do
        post :create, params: {product_id: product, store_release: valid_attributes}, session: valid_session
        expect(assigns(:release)).to be_a(Store::Release)
        expect(assigns(:release)).to be_persisted
      end

      it "redirects to the product's releases" do
        post :create, params: {product_id: product, store_release: valid_attributes}, session: valid_session
        expect(response).to redirect_to(store_product_releases_path(product.id))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved release as @release" do
        post :create, params: {product_id: product, store_release: invalid_attributes}, session: valid_session
        expect(assigns(:release)).to be_a_new(Store::Release)
      end

      it "re-renders the 'new' template" do
        post :create, params: {product_id: product, store_release: invalid_attributes}, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do

      let(:new_product) { FactoryGirl.create(:product) }
      let(:new_attributes) {
        {
          format: "PDF",
          release_date: '2015-11-06 16:42:29.000000000 -0500',
          size: 1.2,
          version: "Third edition"
        }
      }

      it "updates the requested release" do
        release = product.releases.create! valid_attributes
        put :update, params: {product_id: product, id: release.to_param, store_release: new_attributes}, session: valid_session
        release.reload

        expect( release.format ).to eq("PDF")
        expect( release.release_date ).to eq('2015-11-06 16:42:29.000000000 -0500')
        expect( release.size ).to eq(1.2)
        expect( release.version ).to eq("Third edition")
      end

      it "assigns the requested release as @release" do
        release = product.releases.create! valid_attributes
        put :update, params: {product_id: product, id: release.to_param, store_release: valid_attributes}, session: valid_session
        expect(assigns(:release)).to eq(release)
      end

      it "redirects to the product's releases" do
        release = product.releases.create! valid_attributes
        put :update, params: {product_id: product, id: release.to_param, store_release: valid_attributes}, session: valid_session
        expect(response).to redirect_to(store_product_releases_path(release.product_id))
      end
    end

    context "with invalid params" do
      it "assigns the release as @release" do
        release = product.releases.create! valid_attributes
        put :update, params: {product_id: product, id: release.to_param, store_release: invalid_attributes}, session: valid_session
        expect(assigns(:release)).to eq(release)
      end

    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested release" do
      release = product.releases.create! valid_attributes
      expect {
        delete :destroy, params: {product_id: product, id: release.to_param}, session: valid_session
      }.to change(Store::Release, :count).by(-1)
    end

    it "redirects to the releases list for the product" do
      release = product.releases.create! valid_attributes
      delete :destroy, params: {product_id: product, id: release.to_param}, session: valid_session
      expect(response).to redirect_to(store_product_releases_url)
    end
  end

end
