require 'rails_helper'

RSpec.describe PurchasesController, type: :controller do

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

  describe "PUT #update" do
    context "with valid params" do

      let(:new_product)   { FactoryGirl.create(:product) }
      let(:new_user)      { FactoryGirl.create(:user) }

      let(:new_attributes) {
        {
          product_id: new_product.id,
          user_id: new_user.id
        }
      }

      it "updates the requested purchase" do
        purchase = Purchase.create! valid_attributes
        put :update, {:id => purchase.to_param, :purchase => new_attributes}, valid_session
        purchase.reload
        
        expect( purchase.product.id ).to eq(new_product.id)
        expect( purchase.user.id ).to eq(new_user.id)
      end

      it "assigns the requested purchase as @purchase" do
        purchase = Purchase.create! valid_attributes
        put :update, {:id => purchase.to_param, :purchase => valid_attributes}, valid_session
        expect(assigns(:purchase)).to eq(purchase)
      end

      it "redirects to the purchase" do
        purchase = Purchase.create! valid_attributes
        put :update, {:id => purchase.to_param, :purchase => valid_attributes}, valid_session
        expect(response).to redirect_to(purchase)
      end
    end

    context "with invalid params" do
      it "assigns the purchase as @purchase" do
        purchase = Purchase.create! valid_attributes
        put :update, {:id => purchase.to_param, :purchase => invalid_attributes}, valid_session
        expect(assigns(:purchase)).to eq(purchase)
      end

      it "re-renders the 'edit' template" do
        purchase = Purchase.create! valid_attributes
        put :update, {:id => purchase.to_param, :purchase => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested purchase" do
      purchase = Purchase.create! valid_attributes
      expect {
        delete :destroy, {:id => purchase.to_param}, valid_session
      }.to change(Purchase, :count).by(-1)
    end

    it "redirects to the purchases list" do
      purchase = Purchase.create! valid_attributes
      delete :destroy, {:id => purchase.to_param}, valid_session
      expect(response).to redirect_to(purchases_url)
    end
  end

end
