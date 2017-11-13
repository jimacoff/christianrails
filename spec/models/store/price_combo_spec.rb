require 'rails_helper'

RSpec.describe Store::PriceCombo, type: :model do

  let(:product_1)   { FactoryGirl.create(:product) }
  let(:product_2)   { FactoryGirl.create(:product) }

  it "should validate" do
    p = Store::PriceCombo.new
    expect( p ).to_not be_valid
    expect( p.errors.messages.keys ).to include(:name)

    expect( p.errors.messages[:name] ).to include("can't be blank")

    p.name = "Megadeal"
    p.discount_cents = "Rascal"
    expect( p ).to_not be_valid
    expect( p.errors.messages[:discount_cents] ).to include("is not a number")

    p.discount_cents = 2_00
    expect( p ).to be_valid
  end

  it "should have and belong to many products" do
    p = Store::PriceCombo.create(name: "Cat-related bundle", discount_cents: 4_99)
    p.products << product_1
    p.products << product_2

    expect( p.products.count ).to eq(2)
  end

  it "should have many orders" do
    p = Store::PriceCombo.create(name: "Jar-related bundle", discount_cents: 3_99)
    o1 = Store::Order.create(price_combo: p, payment_id: "rakka", payer_id: "snaka",   total_cents: 4_65)
    o2 = Store::Order.create(price_combo: p, payment_id: "arara", payer_id: "maarara", total_cents: 1_75)

    expect( p.orders.count ).to eq(2)
  end

  describe 'satisfied_for?' do

    let(:user) { FactoryGirl.create(:user) }

    let(:product_1)   { FactoryGirl.create(:product, title: "Book One", price: 5_00) }
    let(:product_2)   { FactoryGirl.create(:product, title: "Book Two", price: 3_00) }

    it 'should identify a satisfied combo' do
      combo = Store::PriceCombo.create(name: "Reasonably-priced bundle", discount_cents: 2_50)
      combo.products << product_1
      combo.products << product_2

      st1 = Store::StagedPurchase.create(user: user, product: product_1)
      st2 = Store::StagedPurchase.create(user: user, product: product_2)

      expect( combo.satisfied_for?(user.id) ).to be_truthy
    end

    it 'should identify an unsatisfied combo' do
      combo = Store::PriceCombo.create(name: "Reasonably-priced bundle", discount_cents: 2_50)
      combo.products << product_1
      combo.products << product_2

      st1 = Store::StagedPurchase.create(user: user, product: product_1)

      expect( combo.satisfied_for?(user.id) ).to be_falsy
    end

  end

  describe 'combos_satisfied_for' do

    let(:user) { FactoryGirl.create(:user) }

    let(:product_1)   { FactoryGirl.create(:product, title: "Book One", price_cents: 5_00) }
    let(:product_2)   { FactoryGirl.create(:product, title: "Book Two", price_cents: 3_00) }

    it 'should return an array of the price combos satisfied' do
      combo = Store::PriceCombo.create(name: "Some bundle", discount_cents: 6_50)
      combo.products << product_1
      combo.products << product_2

      st1 = Store::StagedPurchase.create(user: user, product: product_1)
      st2 = Store::StagedPurchase.create(user: user, product: product_2)

      expect( Store::PriceCombo.combos_satisfied_for(user.id) ).to include(combo.id)
    end

  end

  describe 'total_cart_discount_for' do

    let(:user) { FactoryGirl.create(:user) }

    let(:product_1)   { FactoryGirl.create(:product, title: "The main event",        price_cents: 5_00) }
    let(:product_2)   { FactoryGirl.create(:product, title: "Bonus material",        price_cents: 3_00) }
    let(:product_3)   { FactoryGirl.create(:product, title: "Some other product",    price_cents: 4_00) }
    let(:product_4)   { FactoryGirl.create(:product, title: "Surprise product",      price_cents: 2_00) }
    let(:product_5)   { FactoryGirl.create(:product, title: "A sequel no one wants", price_cents: 6_00) }

    let(:staged_purchase)  { FactoryGirl.create(:staged_purchase) }

    it 'should return a discount for one satisfied price combo' do
      combo = Store::PriceCombo.create(name: "Pretty good deal", discount_cents: 2_50)
      combo.products << product_1
      combo.products << product_2

      Store::StagedPurchase.create(user: user, product: product_1)
      Store::StagedPurchase.create(user: user, product: product_2)

      expect( Store::PriceCombo.total_cart_discount_for(user.id) ).to eq(2_50)

    end

    it 'should return a discount for more than one satisfied price combo' do
      combo1 = Store::PriceCombo.create(name: "Pretty good deal", discount_cents: 2_50)
      combo2 = Store::PriceCombo.create(name: "Amazing deal",     discount_cents: 5_25)
      # set up combo 1
      combo1.products << product_1
      combo1.products << product_2
      # set up combo 2
      combo2.products << product_3
      combo2.products << product_4
      combo2.products << product_5

      # fulfill combo 1
      Store::StagedPurchase.create(user: user, product: product_1)
      Store::StagedPurchase.create(user: user, product: product_2)
      # fulfill combo 2
      Store::StagedPurchase.create(user: user, product: product_3)
      Store::StagedPurchase.create(user: user, product: product_4)
      Store::StagedPurchase.create(user: user, product: product_5)

      expect( Store::PriceCombo.total_cart_discount_for(user.id) ).to eq(7_75)
    end

    it 'should not return any discounts if no price combos satisfied' do
      combo1 = Store::PriceCombo.create(name: "Pretty good deal", discount_cents: 2_50)
      combo2 = Store::PriceCombo.create(name: "Amazing deal",     discount_cents: 5_25)
      # set up combo 1
      combo1.products << product_1
      combo1.products << product_2
      # set up combo 2
      combo2.products << product_3
      combo2.products << product_4
      combo2.products << product_5

      Store::StagedPurchase.create(user: user, product: product_1)

      Store::StagedPurchase.create(user: user, product: product_3)
      Store::StagedPurchase.create(user: user, product: product_4)

      expect( Store::PriceCombo.total_cart_discount_for(user.id) ).to eq(0)
    end

  end

end
