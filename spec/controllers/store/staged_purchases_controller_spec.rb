require 'rails_helper'

RSpec.describe Store::StagedPurchasesController, type: :controller do

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

  let(:product)   { FactoryBot.create(:product) }
  let(:user)      { FactoryBot.create(:user) }

  let(:valid_attributes) {
    {
      product_id: product.id,
      type_id: Store::StagedPurchase::TYPE_DIGITAL_SINGLE
    }
  }

  let(:invalid_attributes) {
    {
      bad_id: 7777
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all staged_purchases as @staged_purchases" do
      staged_purchase = Store::StagedPurchase.new valid_attributes
      staged_purchase.user = @user
      staged_purchase.save

      get :index, params: {}, session: valid_session
      expect(assigns(:staged_purchases)).to eq([staged_purchase])
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new StagedPurchase" do
        expect {
          post :create, params: {staged_purchase: valid_attributes, format: :json}, session: valid_session
        }.to change(Store::StagedPurchase, :count).by(1)
      end

      it "creates a new productless StagedPurchase" do
        expect {
          post :create, params: {staged_purchase: {type_id: Store::StagedPurchase::TYPE_LIFETIME_MEMBERSHIP}, format: :json}, session: valid_session
        }.to change(Store::StagedPurchase, :count).by(1)
      end
    end

    context "with invalid params" do
      it "returns an empty hash" do
        post :create, params: {staged_purchase: invalid_attributes, format: :json}, session: valid_session
        expect( JSON.parse(response.body) ).to be_a(Hash)
        expect( JSON.parse(response.body) ).to eq({})
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested staged_purchase" do
      staged_purchase = Store::StagedPurchase.new valid_attributes
      staged_purchase.user = @user
      staged_purchase.save

      expect {
        delete :destroy, params: {id: staged_purchase.id, format: :json}, session: valid_session
      }.to change(Store::StagedPurchase, :count).by(-1)
    end
  end

end
