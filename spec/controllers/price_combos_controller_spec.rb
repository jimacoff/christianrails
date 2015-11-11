require 'rails_helper'

RSpec.describe PriceCombosController, type: :controller do

  let(:valid_attributes) {
    {
      name: "Crazydeal",
      price: 0.99
    }
  }

  let(:invalid_attributes) {
    {
      not_a_name: "This!"
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all price_combos as @price_combos" do
      price_combo = PriceCombo.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:price_combos)).to eq([price_combo])
    end
  end

  describe "GET #new" do
    it "assigns a new price_combo as @price_combo" do
      get :new, {}, valid_session
      expect(assigns(:price_combo)).to be_a_new(PriceCombo)
    end
  end

  describe "GET #edit" do
    it "assigns the requested price_combo as @price_combo" do
      price_combo = PriceCombo.create! valid_attributes
      get :edit, {:id => price_combo.to_param}, valid_session
      expect(assigns(:price_combo)).to eq(price_combo)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new PriceCombo" do
        expect {
          post :create, {:price_combo => valid_attributes}, valid_session
        }.to change(PriceCombo, :count).by(1)
      end

      it "assigns a newly created price_combo as @price_combo" do
        post :create, {:price_combo => valid_attributes}, valid_session
        expect(assigns(:price_combo)).to be_a(PriceCombo)
        expect(assigns(:price_combo)).to be_persisted
      end

      it "redirects to the created price_combo" do
        post :create, {:price_combo => valid_attributes}, valid_session
        expect(response).to redirect_to(PriceCombo.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved price_combo as @price_combo" do
        post :create, {:price_combo => invalid_attributes}, valid_session
        expect(assigns(:price_combo)).to be_a_new(PriceCombo)
      end

      it "re-renders the 'new' template" do
        post :create, {:price_combo => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          name: "Superdeal",
          price: 2.99
        }
      }

      it "updates the requested price_combo" do
        price_combo = PriceCombo.create! valid_attributes
        put :update, {:id => price_combo.to_param, :price_combo => new_attributes}, valid_session
        price_combo.reload
        
        expect( price_combo.name ).to eq("Superdeal")
        expect( price_combo.price ).to eq("2.99")
      end

      it "assigns the requested price_combo as @price_combo" do
        price_combo = PriceCombo.create! valid_attributes
        put :update, {:id => price_combo.to_param, :price_combo => valid_attributes}, valid_session
        expect(assigns(:price_combo)).to eq(price_combo)
      end

      it "redirects to the price_combo" do
        price_combo = PriceCombo.create! valid_attributes
        put :update, {:id => price_combo.to_param, :price_combo => valid_attributes}, valid_session
        expect(response).to redirect_to(price_combo)
      end
    end

    context "with invalid params" do
      it "assigns the price_combo as @price_combo" do
        price_combo = PriceCombo.create! valid_attributes
        put :update, {:id => price_combo.to_param, :price_combo => invalid_attributes}, valid_session
        expect(assigns(:price_combo)).to eq(price_combo)
      end

      it "re-renders the 'edit' template" do
        price_combo = PriceCombo.create! valid_attributes
        put :update, {:id => price_combo.to_param, :price_combo => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested price_combo" do
      price_combo = PriceCombo.create! valid_attributes
      expect {
        delete :destroy, {:id => price_combo.to_param}, valid_session
      }.to change(PriceCombo, :count).by(-1)
    end

    it "redirects to the price_combos list" do
      price_combo = PriceCombo.create! valid_attributes
      delete :destroy, {:id => price_combo.to_param}, valid_session
      expect(response).to redirect_to(price_combos_url)
    end
  end

end
