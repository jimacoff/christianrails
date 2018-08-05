require 'rails_helper'

RSpec.describe Store::DealzoneController, type: :controller do

  render_views

  let(:user)    { FactoryBot.create(:user) }

  let(:valid_session) { {} }

  before (:each) do
    sign_in user

    user.admin = true
    user.save
  end

  describe 'GET #index' do

    let!(:combo1)    { FactoryBot.create(:price_combo) }
    let!(:combo2)    { FactoryBot.create(:price_combo) }
    let!(:combo3)    { FactoryBot.create(:price_combo) }

    let!(:product1)  { FactoryBot.create(:product, title: "Ghostcrime") }
    let!(:product2)  { FactoryBot.create(:product) }
    let!(:product3)  { FactoryBot.create(:product) }
    let!(:product4)  { FactoryBot.create(:product) }
    let!(:product5)  { FactoryBot.create(:product) }

    let(:order1)     { FactoryBot.create(:order, price_combo: combo1, user: user) }
    let(:order2)     { FactoryBot.create(:order, price_combo: combo2, user: user) }
    let(:order3)     { FactoryBot.create(:order, price_combo: combo3, user: user) }

    let!(:digital_purchase1) { FactoryBot.create(:digital_purchase, product: product2, order: order1) }
    let!(:digital_purchase2) { FactoryBot.create(:digital_purchase, product: product4, order: order2) }
    let!(:digital_purchase3) { FactoryBot.create(:digital_purchase, product: product5, order: order3) }

    it 'retrieves all price combos' do
      get 'index'
      expect( assigns(:price_combos).count ).to eq(3)
    end

    it 'retrieves all products the user owns and the others available' do
      get 'index'
      expect( assigns(:all_products).count      ).to eq(5)
      expect( assigns(:owned_products).count    ).to eq(3)
      expect( assigns(:available_products).count).to eq(2)
    end

  end

  describe "GET #library" do
    it "allows access" do
      get :library, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe "GET #memberships" do
    it "allows access" do
      get :memberships, params: {}, session: valid_session
      expect( response ).to be_ok
    end
  end

  describe 'GET #updated_prices' do

    let!(:product_1)   { FactoryBot.create(:product, title: "The main event",     price_cents: 5_05) }
    let!(:product_2)   { FactoryBot.create(:product, title: "Bonus material",     price_cents: 3_00) }
    let!(:product_3)   { FactoryBot.create(:product, title: "Some other product", price_cents: 4_00) }
    let!(:product_4)   { FactoryBot.create(:product, title: "Some other product", price_cents: 7_00) }

    let(:staged_purchase)  { FactoryBot.create(:staged_purchase) }

    it 'returns info for all products and a total discount' do
      get :updated_prices, format: :json
      resp = JSON.parse(response.body)

      expect( resp.keys ).to include("total_discount")
      expect( resp.keys ).to include(product_1.id.to_s, product_2.id.to_s, product_3.id.to_s, product_4.id.to_s)
    end

    it 'returns a discount for product with satisfiable price combo' do
      combo1 = Store::PriceCombo.create(name: "Mini deal",   discount_cents: -0_50)
      combo2 = Store::PriceCombo.create(name: "Bigger deal", discount_cents: -1_00)
      # set up combo 1
      combo1.products << product_1
      combo1.products << product_2
      # set up combo 2
      combo2.products << product_2
      combo2.products << product_3

      Store::StagedPurchase.create(user: user, product: product_2)

      get :updated_prices, format: :json
      resp = JSON.parse(response.body)

      expect( resp[product_1.id.to_s] ).to eq([5_05, -0_50])
      expect( resp[product_3.id.to_s] ).to eq([4_00, -1_00])
      expect( resp["total_discount"] ).to eq(0)  # no combos actually satisfied yet
    end

    it 'returns a combined discount for product with 2 satisfiable price combos' do
      combo1 = Store::PriceCombo.create(name: "Mini deal",   discount_cents:   -50)
      combo2 = Store::PriceCombo.create(name: "Bigger deal", discount_cents: -1_00)
      # set up combo 1
      combo1.products << product_1
      combo1.products << product_2
      # set up combo 2
      combo2.products << product_2
      combo2.products << product_3

      Store::StagedPurchase.create(user: user, product: product_1)
      Store::StagedPurchase.create(user: user, product: product_3)

      get :updated_prices, format: :json
      resp = JSON.parse(response.body)

      expect( resp[product_2.id.to_s] ).to eq([3_00, -1_50])
      expect( resp["total_discount"] ).to eq(0)   # none satisfied yet
    end

    it 'returns a total discount for satisfied combo and discount for potential combo as well' do
      combo1 = Store::PriceCombo.create(name: "Sober deal",     discount_cents:   -99)
      combo2 = Store::PriceCombo.create(name: "Unbridled deal", discount_cents: -3_99)
      # set up combo 1
      combo1.products << product_1
      combo1.products << product_2
      # set up combo 2
      combo2.products << product_3
      combo2.products << product_4

      Store::StagedPurchase.create(user: user, product: product_1)
      Store::StagedPurchase.create(user: user, product: product_2)
      Store::StagedPurchase.create(user: user, product: product_3)

      get :updated_prices, format: :json
      resp = JSON.parse(response.body)

      expect( resp[product_1.id.to_s] ).to eq([5_05, -99])
      expect( resp[product_2.id.to_s] ).to eq([3_00, -99])
      expect( resp[product_3.id.to_s] ).to eq([4_00,  0])
      expect( resp[product_4.id.to_s] ).to eq([7_00, -3_99])

      expect( resp["total_discount"] ).to eq(-99)  # sober deal satisfied
    end

    it 'does NOT return a discount for product with no satisfiable price combo' do
      combo1 = Store::PriceCombo.create(name: "Mini deal",   discount_cents: -0.50)
      combo2 = Store::PriceCombo.create(name: "Bigger deal", discount_cents: -1.00)
      # set up combo 1
      combo1.products << product_1
      combo1.products << product_2
      # set up combo 2
      combo2.products << product_2
      combo2.products << product_3

      get :updated_prices, format: :json
      resp = JSON.parse(response.body)

      expect( resp[product_1.id.to_s] ).to eq([5_05, 0])
      expect( resp[product_2.id.to_s] ).to eq([3_00, 0])
      expect( resp[product_3.id.to_s] ).to eq([4_00, 0])

      expect( resp["total_discount"] ).to eq(0)
    end

  end

  describe 'POST #check_out' do

    let(:froom_product) { FactoryBot.create(:product, title: "Lol Froom") }
    let(:vroom_product) { FactoryBot.create(:product, title: "Lol Vroom") }
    let(:brool_product) { FactoryBot.create(:product, title: "Lol Brool") }
    let(:physi_product) { FactoryBot.create(:product, title: "Physi prod") }

    let(:staged_purchase)  { FactoryBot.create(:staged_purchase, user: user, product: froom_product) }
    let(:staged_purchase2) { FactoryBot.create(:staged_purchase, user: user, product: vroom_product) }
    let(:staged_giftpack_purchase) { FactoryBot.create(:staged_purchase, user: user, product: brool_product, type_id: Store::StagedPurchase::TYPE_DIGITAL_GIFT_PACK) }
    let(:staged_physical_purchase) { FactoryBot.create(:staged_purchase, user: user, product: physi_product, type_id: Store::StagedPurchase::TYPE_PHYSICAL_SINGLE) }
    let(:staged_membership) { FactoryBot.create(:staged_purchase, user: user, type_id: Store::StagedPurchase::TYPE_LIFETIME_MEMBERSHIP) }

    it "sends off to PayPal if everything is fine" do
      staged_purchase.save
      staged_purchase2.save
      staged_giftpack_purchase.save
      staged_physical_purchase.save
      staged_membership.save

      expect{
        post 'check_out'
      }.to change(Log, :count).by( 1 )
      expect( response ).to_not redirect_to( root_path )

      sent_subtotal = assigns[:payment].transactions[0].amount.details.subtotal
      sent_tax      = assigns[:payment].transactions[0].amount.details.tax
      sent_total    = assigns[:payment].transactions[0].amount.total

      digital_prices = froom_product.price_cents + vroom_product.price_cents + brool_product.giftpack_price_cents + Store::LifetimeMembership::CURRENT_PRICE_CENTS
      physical_prices = physi_product.physical_price_cents

      # phys price: $10 --> $0.50 tax
      # digital: $47.36 --> $7.61 tax

      expect( sent_subtotal ).to eq( "57.36" )
      expect( sent_tax ).to eq( "7.61" )
      expect( sent_total ).to eq( "64.97" )
    end

    it "redirects home if no staged purchases" do
      post 'check_out'
      expect( response ).to redirect_to( root_path )
    end

  end

  describe 'GET #complete_order' do

    before :each do
      PayPal::SDK::REST::Payment.stubs(:find).returns( PayPal::SDK::REST::Payment.new )
      PayPal::SDK::REST::Payment.any_instance.stubs(:execute).returns(true)
    end

    let(:product1) { FactoryBot.create(:product, price_cents: 3_00, shipping_cost_cents: 5_00) }
    let(:product2) { FactoryBot.create(:product, price_cents: 7_00) }

    let(:staged_purchase1) { FactoryBot.create(:staged_purchase, user: user, product: product1) }
    let(:staged_purchase2) { FactoryBot.create(:staged_purchase, user: user, product: product2) }

    let(:staged_giftpack_purchase) { FactoryBot.create(:staged_purchase, user: user, product: product1, type_id: Store::StagedPurchase::TYPE_DIGITAL_GIFT_PACK) }
    let(:staged_physical_purchase) { FactoryBot.create(:staged_purchase, user: user, product: product1, type_id: Store::StagedPurchase::TYPE_PHYSICAL_SINGLE) }

    let(:staged_membership) { FactoryBot.create(:staged_purchase, user: user, type_id: Store::StagedPurchase::TYPE_LIFETIME_MEMBERSHIP) }


    it "creates purchases and gifts for each normal eBook staged purchase" do
      staged_purchase1.save; staged_purchase2.save
      get 'complete_order', params: { paymentId: "some_payment_id", token: 'some_token', PayerID: 'some_payer_id' }

      expect( Store::StagedPurchase.count  ).to eq(0)

      expect( Store::DigitalPurchase.count ).to eq(2)
      digital_purchase1 = Store::DigitalPurchase.all[0]
      expect( digital_purchase1.price_cents ).to eq(3_00)
      digital_purchase2 = Store::DigitalPurchase.all[1]
      expect( digital_purchase2.price_cents ).to eq(7_00)

      expect( Store::FreeGift.count        ).to eq(2)
      expect( Store::Order.count ).to eq(1)
    end

    it "creates purchases and gifts for a staged purchase that's a 5x gift pack purchase" do
      staged_giftpack_purchase.save

      get 'complete_order', params: { paymentId: "some_payment_id", token: 'some_token', PayerID: 'some_payer_id' }

      expect( Store::StagedPurchase.count  ).to eq(0)

      expect( Store::DigitalPurchase.count ).to eq(1)
      digital_purchase = Store::DigitalPurchase.take
      expect( digital_purchase.price_cents ).to eq(14_44) # giftpack price

      expect( Store::FreeGift.count ).to eq(5)
      expect( Store::Order.count ).to eq(1)
    end

    it "creates purchases for a staged purchase that's a physical book" do
      staged_physical_purchase.save

      get 'complete_order', params: { paymentId: "some_payment_id", token: 'some_token', PayerID: 'some_payer_id' }

      expect( Store::StagedPurchase.count  ).to eq(0)

      expect( Store::PhysicalPurchase.count ).to eq(1)
      physical_purchase = Store::PhysicalPurchase.take
      expect( physical_purchase.price_cents ).to eq(10_00)

      expect( Store::Order.count ).to eq(1)
      order = Store::Order.take
      expect( order.shipping_cost_cents ).to eq( 5_00 )
      expect( order.tax_cents ).to eq( 50 )  # $10 * 5%
      expect( order.total_cents ).to eq( 15_50 )
    end

    it "creates a LifetimeMembership for a staged purchase that's for that" do
      staged_membership.save

      get 'complete_order', params: { paymentId: "some_payment_id", token: 'some_token', PayerID: 'some_payer_id' }

      expect( Store::StagedPurchase.count  ).to eq(0)

      expect( Store::LifetimeMembership.count ).to eq(1)
      lifetime_membership = Store::LifetimeMembership.take
      expect( lifetime_membership.cost_cents ).to eq(17_38)

      expect( Store::Order.count ).to eq(1)
      order = Store::Order.take
      expect( order.shipping_cost_cents ).to eq( 0 )
      expect( order.tax_cents ).to eq( 2_61 )  # 19_99 - 17_38
      expect( order.total_cents ).to eq( 19_99 )

      expect( order.lifetime_memberships ).to include( lifetime_membership )
      expect( lifetime_membership.order ).to eq( order )
    end

    it "creates an order with the correct total, tax and no discount" do
      staged_purchase1.save; staged_purchase2.save; staged_physical_purchase.save

      expect {
        get :complete_order, params: { paymentId: "some_payment_id", token: 'some_token', PayerID: 'some_payer_id' }
      }.to change{ Store::Order.count }.by (1)

      order = Store::Order.first

      expect( order.discount_cents ).to eq(0)
      expect( order.shipping_cost_cents ).to eq( 5_00 )
      expect( order.tax_cents ).to eq( ( (product1.price_cents + product2.price_cents ) * Store::DigitalPurchase::TAX_RATE) + (product1.physical_price_cents * Store::PhysicalPurchase::TAX_RATE) )
      expect( order.total_cents ).to eq( product1.price_cents + product2.price_cents + product1.physical_price_cents + order.tax_cents + order.shipping_cost_cents )
    end

    it "creates an order with the correct discount when applicable" do
      staged_purchase1.save; staged_purchase2.save

      combo1 = Store::PriceCombo.create(name: "Great deal", discount_cents: 2_50)
      combo1.products << product1
      combo1.products << product2

      get 'complete_order', params: { paymentId: "some_payment_id", token: 'some_token', PayerID: 'some_payer_id' }

      order = Store::Order.first

      expect( order.discount_cents ).to eq( 2_50 )
      expect( order.shipping_cost_cents ).to eq( 0 )
      expect( order.tax_cents ).to be_within(1).of( ((product1.price_cents + product2.price_cents) - order.discount_cents) * Store::DigitalPurchase::TAX_RATE )
      expect( order.total_cents ).to eq( product1.price_cents + product2.price_cents + order.tax_cents - order.discount_cents )
    end

  end

  describe 'GET #download' do

    let!(:product1)  { FactoryBot.create(:product) }
    let!(:product2)  { FactoryBot.create(:product) }

    let!(:release1)  { FactoryBot.create(:release, product: product1) }
    let!(:release2)  { FactoryBot.create(:release, product: product2) }

    let!(:order) { FactoryBot.create(:order, user: user) }

    let!(:digital_purchase1)  { FactoryBot.create(:digital_purchase, product: product1, order: order) }

    let(:invalid_release_id) {-33}

    before :each do
      controller.stubs(:render)
    end

    it 'downloads for an authorized logged-in user and notifies the admin of the download' do
      ActionMailer::Base.deliveries = []
      controller.stubs(:send_file).returns("Download successful").once

      get 'download', params: { release_id: release1.id }
      expect( response.status ).to eq(200)
      expect( assigns[:error] ).to be_nil

      expect( ActionMailer::Base.deliveries.size ).to eq(1)
    end

    it 'does NOT download if no user logged in' do
      sign_out user

      controller.stubs(:send_file).returns("Download successful").never

      get 'download', params: { release_id: release1.id }
      expect( response.status ).to eq(302)
      expect( assigns[:error] ).to_not be_nil
    end

    it 'does NOT download if user does not own the product' do
      controller.stubs(:send_file).returns("Download successful").never

      get 'download', params: { release_id: release2.id }
      expect( response.status ).to eq(302)
      expect( assigns[:error] ).to_not be_nil
    end

    it 'does NOT download anything if release_id is invalid' do
      controller.stubs(:send_file).returns("Download successful").never

      get 'download', params: { release_id: invalid_release_id }
      expect( response.status ).to eq(302)
      expect( assigns[:error] ).to_not be_nil
    end

    it 'does NOT download if user has downloaded release too many times' do
      controller.stubs(:send_file).returns("Download successful").times( Store::Download::LIMIT )

      ( Store::Download::LIMIT + 1 ).times do
        get 'download', params: { release_id: release1.id }
      end
      expect( assigns[:error] ).to_not be_nil
    end

  end

end
