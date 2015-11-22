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

end
