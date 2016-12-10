require 'rails_helper'

RSpec.describe StoreController, type: :controller do

  render_views

  let(:user)    { FactoryGirl.create(:user) }

  before (:each) do
    sign_in user

    user.admin = true
    user.save

    #controller.class.skip_before_action :verify_is_admin
  end

  describe 'index' do

    let!(:combo1)    { FactoryGirl.create(:price_combo) }
    let!(:combo2)    { FactoryGirl.create(:price_combo) }
    let!(:combo3)    { FactoryGirl.create(:price_combo) }

    let!(:product1)  { FactoryGirl.create(:product, title: "Ghostcrime") }
    let!(:product2)  { FactoryGirl.create(:product) }
    let!(:product3)  { FactoryGirl.create(:product) }
    let!(:product4)  { FactoryGirl.create(:product) }
    let!(:product5)  { FactoryGirl.create(:product) }

    let(:order1)     { FactoryGirl.create(:order, price_combo: combo1, user: user) }
    let(:order2)     { FactoryGirl.create(:order, price_combo: combo2, user: user) }
    let(:order3)     { FactoryGirl.create(:order, price_combo: combo3, user: user) }

    let!(:purchase1) { FactoryGirl.create(:purchase, product: product2, order: order1) }
    let!(:purchase2) { FactoryGirl.create(:purchase, product: product4, order: order2) }
    let!(:purchase3) { FactoryGirl.create(:purchase, product: product5, order: order3) }

    it 'should retrieve all price combos' do
      get 'index'
      expect( assigns(:price_combos).count ).to eq(3)
    end

    it 'should retrieve all products the user owns and the others available' do
      get 'index'
      expect( assigns(:all_products).count ).to eq(5)
      expect( assigns(:owned_products).count ).to eq(3)
      expect( assigns(:available_products).count).to eq(2)
    end

  end

  describe 'updated prices' do

    let!(:product_1)   { FactoryGirl.create(:product, title: "The main event", price: 5.05) }
    let!(:product_2)   { FactoryGirl.create(:product, title: "Bonus material", price: 3.00) }
    let!(:product_3)   { FactoryGirl.create(:product, title: "Some other product", price: 4.00) }
    let!(:product_4)   { FactoryGirl.create(:product, title: "Some other product", price: 7.00) }

    let(:staged_purchase)  { FactoryGirl.create(:staged_purchase) }

    it 'should return info for all products and a total discount' do
      get :updated_prices, format: :json
      resp = JSON.parse(response.body)

      expect( resp.keys ).to include("total_discount")
      expect( resp.keys ).to include(product_1.id.to_s, product_2.id.to_s, product_3.id.to_s, product_4.id.to_s)
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

      expect( resp[product_1.id.to_s] ).to eq([5.05,-0.5])
      expect( resp[product_3.id.to_s] ).to eq([4.0, -1.0])
      expect( resp["total_discount"] ).to eq(0)  # no combos actually satisfied yet
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

      expect( resp[product_2.id.to_s] ).to eq([3.0,-1.5])
      expect( resp["total_discount"] ).to eq(0)   # none satisfied yet
    end

    it 'should return a total discount for satisfied combo and discount for potential combo as well' do
      combo1 = PriceCombo.create(name: "Sober deal",   discount: -0.99)
      combo2 = PriceCombo.create(name: "Unbridled deal", discount: -3.99)
      # set up combo 1
      combo1.products << product_1
      combo1.products << product_2
      # set up combo 2
      combo2.products << product_3
      combo2.products << product_4

      StagedPurchase.create(user: user, product: product_1)
      StagedPurchase.create(user: user, product: product_2)
      StagedPurchase.create(user: user, product: product_3)

      get :updated_prices, format: :json
      resp = JSON.parse(response.body)

      expect( resp[product_1.id.to_s] ).to eq([5.05,-0.99])
      expect( resp[product_2.id.to_s] ).to eq([3.0, -0.99])
      expect( resp[product_3.id.to_s] ).to eq([4.0, 0])
      expect( resp[product_4.id.to_s] ).to eq([7.0, -3.99])

      expect( resp["total_discount"] ).to eq(-0.99)  # sober deal satisfied
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

      expect( resp[product_1.id.to_s] ).to eq([5.05,0])
      expect( resp[product_2.id.to_s] ).to eq([3.0, 0])
      expect( resp[product_3.id.to_s] ).to eq([4.0, 0])

      expect( resp["total_discount"] ).to eq(0)
    end

  end

  describe 'complete_order' do

    before :each do
      PayPal::SDK::REST::Payment.stubs(:find).returns( PayPal::SDK::REST::Payment.new )
      PayPal::SDK::REST::Payment.any_instance.stubs(:execute).returns(true)
    end

    let(:product1) { FactoryGirl.create(:product, price: 3.00) }
    let(:product2) { FactoryGirl.create(:product, price: 7.00) }

    let!(:staged_purchase1) { FactoryGirl.create(:staged_purchase, user: user, product: product1) }
    let!(:staged_purchase2) { FactoryGirl.create(:staged_purchase, user: user, product: product2) }

    it "should create purchases for each staged purchase" do

      get 'complete_order', params: { paymentId: "some_payment_id", token: 'some_token', PayerID: 'some_payer_id' }

      expect( StagedPurchase.count ).to eq(0)
      expect( Purchase.count ).to eq(2)

    end

    it "should create an order with the correct total, tax and no discount" do
      expect {
        get :complete_order, params: { paymentId: "some_payment_id", token: 'some_token', PayerID: 'some_payer_id' }
      }.to change{ Order.count }.by (1)

      order = Order.first

      expect( order.discount ).to eq(0)
      expect( order.tax ).to eq( ( product1.price + product2.price ) * Purchase::TAX_RATE )
      expect( order.total ).to eq( product1.price + product2.price + order.tax )
    end

    it "should create an order with the correct discount when applicable" do
      combo1 = PriceCombo.create(name: "Great deal", discount: 2.50)
      combo1.products << product1
      combo1.products << product2

      get 'complete_order', params: { paymentId: "some_payment_id", token: 'some_token', PayerID: 'some_payer_id' }

      order = Order.first

      expect( order.discount ).to eq( 2.50 )
      expect( order.tax ).to eq( ((product1.price + product2.price) - order.discount) * Purchase::TAX_RATE )
      expect( order.total ).to eq( product1.price + product2.price + order.tax - order.discount )
    end

  end

  describe 'download' do

    let!(:product1)  { FactoryGirl.create(:product) }
    let!(:product2)  { FactoryGirl.create(:product) }

    let!(:release1)  { FactoryGirl.create(:release, product: product1) }
    let!(:release2)  { FactoryGirl.create(:release, product: product2) }

    let!(:order) { FactoryGirl.create(:order, user: user) }

    let!(:purchase1)  { FactoryGirl.create(:purchase, product: product1, order: order) }

    let(:invalid_release_id) {-33}

    before :each do
      controller.stubs(:render)
    end

    it 'should download for an authorized logged-in user' do
      controller.stubs(:send_file).returns("Download successful").once

      get 'download', params: { release_id: release1.id }
      expect( response.status ).to eq(200)
      expect( assigns[:error] ).to be_nil
    end

    it 'should NOT download if no user logged in' do
      sign_out user

      controller.stubs(:send_file).returns("Download successful").never

      get 'download', params: { release_id: release1.id }
      expect( response.status ).to eq(302)
      expect( assigns[:error] ).to_not be_nil
    end

    it 'should NOT download if user does not own the product' do
      controller.stubs(:send_file).returns("Download successful").never

      get 'download', params: { release_id: release2.id }
      expect( response.status ).to eq(302)
      expect( assigns[:error] ).to_not be_nil
    end

    it 'should NOT download anything if release_id is invalid' do
      controller.stubs(:send_file).returns("Download successful").never

      get 'download', params: { release_id: invalid_release_id }
      expect( response.status ).to eq(302)
      expect( assigns[:error] ).to_not be_nil
    end

    it 'should NOT download if user has downloaded release too many times' do
      controller.stubs(:send_file).returns("Download successful").times( Download::LIMIT )

      ( Download::LIMIT + 1 ).times do
        get 'download', params: { release_id: release1.id }
      end
      expect( assigns[:error] ).to_not be_nil
    end

  end

end
