require 'rails_helper'

RSpec.describe Store::PriceCombosController, type: :controller do

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

    #controller.class.skip_before_action :verify_is_admin
  end

  let(:valid_attributes) {
    {
      name: "Crazydeal",
      discount: 0.99
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
      price_combo = Store::PriceCombo.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:price_combos)).to eq([price_combo])
    end
  end

  describe "GET #new" do
    it "assigns a new price_combo as @price_combo" do
      get :new, params: {}, session: valid_session
      expect(assigns(:price_combo)).to be_a_new(Store::PriceCombo)
    end
  end

  describe "GET #edit" do
    it "assigns the requested price_combo as @price_combo" do
      price_combo = Store::PriceCombo.create! valid_attributes
      get :edit, params: {id: price_combo.to_param}, session: valid_session
      expect(assigns(:price_combo)).to eq(price_combo)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new PriceCombo" do
        expect {
          post :create, params: {store_price_combo: valid_attributes}, session: valid_session
        }.to change(Store::PriceCombo, :count).by(1)
      end

      it "assigns a newly created price_combo as @price_combo" do
        post :create, params: {store_price_combo: valid_attributes}, session: valid_session
        expect(assigns(:price_combo)).to be_a(Store::PriceCombo)
        expect(assigns(:price_combo)).to be_persisted
      end

      it "redirects to the index" do
        post :create, params: {store_price_combo: valid_attributes}, session: valid_session
        expect(response).to redirect_to(store_price_combos_url)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved price_combo as @price_combo" do
        post :create, params: {store_price_combo: invalid_attributes}, session: valid_session
        expect(assigns(:price_combo)).to be_a_new(Store::PriceCombo)
      end

      it "re-renders the 'new' template" do
        post :create, params: {store_price_combo: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          name: "Superdeal",
          discount: 2.99
        }
      }

      it "updates the requested price_combo" do
        price_combo = Store::PriceCombo.create! valid_attributes
        put :update, params: {id: price_combo.to_param, store_price_combo: new_attributes}, session: valid_session
        price_combo.reload

        expect( price_combo.name ).to eq("Superdeal")
        expect( price_combo.discount ).to eq(2.99)
      end

      it "assigns the requested price_combo as @price_combo" do
        price_combo = Store::PriceCombo.create! valid_attributes
        put :update, params: {id: price_combo.to_param, store_price_combo: valid_attributes}, session: valid_session
        expect(assigns(:price_combo)).to eq(price_combo)
      end

      it "redirects to the price_combos index" do
        price_combo = Store::PriceCombo.create! valid_attributes
        put :update, params: {id: price_combo.to_param, store_price_combo: valid_attributes}, session: valid_session
        expect(response).to redirect_to(store_price_combos_url)
      end
    end

    context "with invalid params" do
      it "assigns the price_combo as @price_combo" do
        price_combo = Store::PriceCombo.create! valid_attributes
        put :update, params: {id: price_combo.to_param, store_price_combo: invalid_attributes}, session: valid_session
        expect(assigns(:price_combo)).to eq(price_combo)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested price_combo" do
      price_combo = Store::PriceCombo.create! valid_attributes
      expect {
        delete :destroy, params: {id: price_combo.to_param}, session: valid_session
      }.to change(Store::PriceCombo, :count).by(-1)
    end

    it "redirects to the price_combos list" do
      price_combo = Store::PriceCombo.create! valid_attributes
      delete :destroy, params: {id: price_combo.to_param}, session: valid_session
      expect(response).to redirect_to(store_price_combos_url)
    end
  end

end
