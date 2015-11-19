require 'rails_helper'

RSpec.describe StoreController, type: :controller do

  let(:user)    { FactoryGirl.create(:user) }
  before (:each) do

    sign_in user
  end

  describe 'updated prices' do
    
    let!(:product_1)   { FactoryGirl.create(:product, title: "The main event", price: 5.05) }
    let!(:product_2)   { FactoryGirl.create(:product, title: "Bonus material", price: 3.00) }
    let!(:product_3)   { FactoryGirl.create(:product, title: "Some other product", price: 4.00) }

    let(:staged_purchase)  { FactoryGirl.create(:staged_purchase) }

    it 'should return info for all products and a total discount' do
      get :updated_prices, format: :json
      resp = JSON.parse(response.body)

      expect( resp.keys ).to include("total_discount")
      expect( resp.keys ).to include(product_1.id.to_s, product_2.id.to_s, product_3.id.to_s)
    end

    it 'should return a discount for product with satisfiable price combo' do
      combo1 = PriceCombo.create(name: "Mini deal",   discount: -0.50)
      combo2 = PriceCombo.create(name: "Bigger deal", discount: -1.00)
      # set up combo 1
      combo1.products << product_1
      combo1.products << product_2
      # set up combo 2
      combo2.products << product_2
      combo2.products << product_3

      StagedPurchase.create(user: user, product: product_2)

      get :updated_prices, format: :json
      resp = JSON.parse(response.body)

      expect( resp[product_1.id.to_s] ).to eq(["5.05","-0.5"])
      expect( resp[product_3.id.to_s] ).to eq(["4.0","-1.0"])

    end

    it 'should return a combined discount for product with 2 satisfiable price combos' do
      combo1 = PriceCombo.create(name: "Mini deal",   discount: -0.50)
      combo2 = PriceCombo.create(name: "Bigger deal", discount: -1.00)
      # set up combo 1
      combo1.products << product_1
      combo1.products << product_2
      # set up combo 2
      combo2.products << product_2
      combo2.products << product_3

      StagedPurchase.create(user: user, product: product_1)
      StagedPurchase.create(user: user, product: product_3)

      get :updated_prices, format: :json
      resp = JSON.parse(response.body)

      expect( resp[product_2.id.to_s] ).to eq(["3.0","-1.5"])

    end

    it 'should not return a discount for product with no satisfiable price combo' do
      combo1 = PriceCombo.create(name: "Mini deal",   discount: -0.50)
      combo2 = PriceCombo.create(name: "Bigger deal", discount: -1.00)
      # set up combo 1
      combo1.products << product_1
      combo1.products << product_2
      # set up combo 2
      combo2.products << product_2
      combo2.products << product_3

      get :updated_prices, format: :json
      resp = JSON.parse(response.body)



    end

    it 'should return a correct total discount' do



      get :updated_prices, format: :json
      resp = JSON.parse(response.body)


    end

  end
  
end
