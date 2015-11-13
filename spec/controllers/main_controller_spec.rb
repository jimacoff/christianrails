require 'rails_helper'

RSpec.describe MainController, type: :controller do

  describe 'store' do 

    let(:user)       { FactoryGirl.create(:user) }

    let(:product1)   { FactoryGirl.create(:product, title: "Cool product") }
    let(:product2)   { FactoryGirl.create(:product, title: "Awesome product") }
    let(:product3)   { FactoryGirl.create(:product, title: "Tubular product") }

    let(:purchase1)  { FactoryGirl.create(:purchase, product: product2, user: user) }

    describe 'for logged-out user' do

      it 'should display all available products' do
        skip("Do it")
      end

    end

    describe 'for logged-on user' do

      it 'should display owned products and other products' do
        skip("Do it")
      end

    end

  end
end
