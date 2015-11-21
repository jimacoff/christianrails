require 'rails_helper'

RSpec.describe MainController, type: :controller do

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


  describe 'index' do 

    let(:user)       { FactoryGirl.create(:user) }

    let(:product1)   { FactoryGirl.create(:product, title: "Cool product") }
    let(:product2)   { FactoryGirl.create(:product, title: "Awesome product") }
    let(:product3)   { FactoryGirl.create(:product, title: "Tubular product") }

    let(:purchase1)  { FactoryGirl.create(:purchase, product: product2, user: user) }

    describe 'for logged-out user' do

      it 'should display all available products' do
        get :index
        
        skip("Do it")
      end

    end

    describe 'for logged-in user' do

      it 'should display owned products and other products' do
        get :index

        skip("Do it")
      end

    end

  end


end