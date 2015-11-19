require 'rails_helper'

RSpec.describe PurchasesController, type: :controller do

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
    it "assigns all purchases as @purchases" do
      purchase = Purchase.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:purchases)).to eq([purchase])
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Purchase" do
        expect {
          post :create, {:purchase => valid_attributes}, valid_session
        }.to change(Purchase, :count).by(1)
      end

      it "assigns a newly created purchase as @purchase" do
        post :create, {:purchase => valid_attributes}, valid_session
        expect(assigns(:purchase)).to be_a(Purchase)
        expect(assigns(:purchase)).to be_persisted
      end

      it "redirects to home" do
        post :create, {:purchase => valid_attributes}, valid_session
        expect(response).to redirect_to(store_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved purchase as @purchase" do
        post :create, {:purchase => invalid_attributes}, valid_session
        expect(assigns(:purchase)).to be_a_new(Purchase)
      end

      it "goes home" do
        post :create, {:purchase => invalid_attributes}, valid_session
        expect(response).to redirect_to store_path
      end
    end
  end

end
