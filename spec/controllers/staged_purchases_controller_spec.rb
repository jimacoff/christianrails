require 'rails_helper'

RSpec.describe StagedPurchasesController, type: :controller do

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
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
          post :create, {:staged_purchase => valid_attributes}, valid_session
        }.to change(StagedPurchase, :count).by(1)
      end

      it "assigns a newly created staged_purchase as @staged_purchase" do
        post :create, {:staged_purchase => valid_attributes}, valid_session
        expect(assigns(:staged_purchase)).to be_a(StagedPurchase)
        expect(assigns(:staged_purchase)).to be_persisted
      end

      it "redirects to the created staged_purchase" do
        post :create, {:staged_purchase => valid_attributes}, valid_session
        expect(response).to redirect_to(StagedPurchase.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved staged_purchase as @staged_purchase" do
        post :create, {:staged_purchase => invalid_attributes}, valid_session
        expect(assigns(:staged_purchase)).to be_a_new(StagedPurchase)
      end

      it "re-renders the 'new' template" do
        post :create, {:staged_purchase => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested staged_purchase" do
      staged_purchase = StagedPurchase.create! valid_attributes
      expect {
        delete :destroy, {:id => staged_purchase.to_param}, valid_session
      }.to change(StagedPurchase, :count).by(-1)
    end

    it "redirects to the staged_purchases list" do
      staged_purchase = StagedPurchase.create! valid_attributes
      delete :destroy, {:id => staged_purchase.to_param}, valid_session
      expect(response).to redirect_to(staged_purchases_url)
    end
  end

end
