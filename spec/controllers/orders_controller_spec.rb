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

end
