require 'rails_helper'

RSpec.describe PurchasesController, type: :controller do

  render_views

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

      it "redirects to the created purchase" do
        post :create, {:purchase => valid_attributes}, valid_session
        expect(response).to redirect_to(Purchase.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved purchase as @purchase" do
        post :create, {:purchase => invalid_attributes}, valid_session
        expect(assigns(:purchase)).to be_a_new(Purchase)
      end

      it "re-renders the 'new' template" do
        post :create, {:purchase => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

end
