require 'rails_helper'

RSpec.describe Store::OrdersController, type: :controller do

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
    @user.admin = true
    @user.save
    sign_in @user
  end

  let(:price_combo)   { FactoryGirl.create(:price_combo) }

  let(:valid_attributes) {
    {
      user_id: @user.id,
      price_combo_id: price_combo.id,
      payer_id: "john payer",
      payment_id: "a-payment-id",
      total: 4.33,
      tax: 1.22,
      discount: 0
    }
  }

  let(:invalid_attributes) {
    {
      bad_id: 7777,
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do

    let(:order)    { FactoryGirl.create(:order, user: @user) }
    let!(:digital_purchase) { FactoryGirl.create(:digital_purchase, order: order) }

    it "assigns all orders as @orders" do
      get :index, params: {}, session: valid_session
      expect(assigns(:orders)).to eq([order])
    end
  end

  describe "GET #show" do

    let(:order)    { FactoryGirl.create(:order, user: @user) }
    let!(:digital_purchase) { FactoryGirl.create(:digital_purchase, order: order) }

    it "retrieves an order for a user" do
      get :show, params: {id: order.id}, session: valid_session

      expect(response).to be_success
      expect(assigns(:order)).to eq(order)
    end
  end

  describe "receipts" do

    let(:order)    { FactoryGirl.create(:order, user: @user) }
    let!(:digital_purchase) { FactoryGirl.create(:digital_purchase, order: order) }

    it "retrieves receipts for a logged-in user with digital_purchases" do
      get :receipts

      expect(response).to be_success
      expect(assigns(:orders)).to eq([order])
    end

    it "retrieves no receipts for non-logged-in user" do
      sign_out @user

      get :receipts

      expect(response).to be_success
      expect(assigns(:orders)).to be_nil
    end

  end

end
