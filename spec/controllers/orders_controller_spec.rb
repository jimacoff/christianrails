require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

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

    controller.class.skip_before_filter :verify_is_admin
  end

  let(:price_combo)   { FactoryGirl.create(:price_combo) }

  let(:valid_attributes) {
    {
      price_combo_id: price_combo.id,
      payer_id: "john payer",
      payment_id: "a-payment-id",
      total: 4.33
    }
  }

  let(:invalid_attributes) {
    {
      bad_id: 7777,
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all orders as @orders" do
      order = Order.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:orders)).to eq([order])
    end
  end

  describe "show" do

    let(:order)    { FactoryGirl.create(:order) }
    let(:purchase) { FactoryGirl.create(:purchase, user: @user) }

    it "retrieves an order for a user" do
      order.purchases << purchase

      get :show, {id: order.id}, valid_session

      expect(response).to be_success
      expect(assigns(:order)).to eq(order)
    end
  end

  describe "receipts" do

    let(:order)    { FactoryGirl.create(:order) }
    let(:purchase) { FactoryGirl.create(:purchase, user: @user) }

    it "retrieves receipts for a logged-in user with purchases" do
      order.purchases << purchase

      get :receipts

      expect(response).to be_success
      expect(assigns(:orders)).to eq([order])
    end

    it "retrieves no receipts for non-logged-in user" do
      sign_out @user
      order.purchases << purchase

      get :receipts

      expect(response).to be_success
      expect(assigns(:orders)).to be_nil
    end

  end

end
