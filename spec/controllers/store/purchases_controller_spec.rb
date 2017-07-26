require 'rails_helper'

RSpec.describe Store::PurchasesController, type: :controller do

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
  end

  let(:product)   { FactoryGirl.create(:product) }
  let(:user)      { FactoryGirl.create(:user) }
  let(:order)     { FactoryGirl.create(:order) }

  let(:valid_attributes) {
    {
      product_id: product.id,
      order_id: order.id,
      price: 4.33
    }
  }

  let(:invalid_attributes) {
    {
      bad_id: 7777
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all purchases as @purchases" do
      purchase = Store::Purchase.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:purchases)).to eq([purchase])
    end
  end

end
