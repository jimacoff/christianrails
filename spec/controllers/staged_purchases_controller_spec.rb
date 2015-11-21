require 'rails_helper'

RSpec.describe StagedPurchasesController, type: :controller do

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

  let(:product)   { FactoryGirl.create(:product) }
  let(:user)      { FactoryGirl.create(:user) }

  let(:valid_attributes) {
    {
      product_id: product.id,
      user_id: user.id
    }
  }

  let(:invalid_attributes) {
    {
      bad_id: 7777,
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all staged_purchases as @staged_purchases" do
      staged_purchase = StagedPurchase.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:staged_purchases)).to eq([staged_purchase])
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new StagedPurchase" do
        expect {
          post :create, {:staged_purchase => valid_attributes, format: :json}, valid_session
        }.to change(StagedPurchase, :count).by(1)
      end

      it "assigns a newly created staged_purchase as @staged_purchase" do
        post :create, {:staged_purchase => valid_attributes, format: :json}, valid_session
        expect(assigns(:staged_purchase)).to be_a(StagedPurchase)
        expect(assigns(:staged_purchase)).to be_persisted
      end

    end

    context "with invalid params" do
      it "assigns a newly created but unsaved staged_purchase as @staged_purchase" do
        post :create, {:staged_purchase => invalid_attributes, format: :json}, valid_session
        expect(assigns(:staged_purchase)).to be_a_new(StagedPurchase)
      end

    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested staged_purchase" do
      staged_purchase = StagedPurchase.create! valid_attributes
      expect {
        delete :destroy, {id: staged_purchase.to_param, format: :json}, valid_session
      }.to change(StagedPurchase, :count).by(-1)
    end
  end

end
