require 'rails_helper'

RSpec.describe PriceCombo, type: :model do

  let(:product_1)   { FactoryGirl.create(:product) }
  let(:product_2)   { FactoryGirl.create(:product) }

  it "should validate" do
    p = PriceCombo.new()
    expect( p ).to_not be_valid
    expect( p.errors.messages.keys ).to include(:name, :discount)

    expect( p.errors.messages[:name] ).to include("can't be blank")
    expect( p.errors.messages[:discount] ).to include("can't be blank")

    p.name = "Megadeal"
    p.discount = "Rascal"
    expect( p ).to_not be_valid
    expect( p.errors.messages[:discount] ).to include("is not a number")

    p.discount = -2.00
    expect( p ).to be_valid
  end

  it "should have and belong to many products" do
    p = PriceCombo.create(name: "Cat-related bundle", discount: -4.99)
    p.products << product_1
    p.products << product_2

    expect( p.products.count ).to eq(2)
  end

  it "should have many orders" do
    p = PriceCombo.create(name: "Jar-related bundle", discount: -3.99)
    o1 = Order.create(price_combo: p, payment_id: "rakka", payer_id: "snaka", total: 4.65)
    o2 = Order.create(price_combo: p, payment_id: "arara", payer_id: "maarara", total: 1.75)

    expect( p.orders.count ).to eq(2)
  end

  describe 'satisfied_for?' do

    let(:user) { FactoryGirl.create(:user) }

    let(:product_1)   { FactoryGirl.create(:product, title: "Book One", price: 5.00) }
    let(:product_2)   { FactoryGirl.create(:product, title: "Book Two", price: 3.00) }

    it 'should identify a satisfied combo' do
      combo = PriceCombo.create(name: "Reasonably-priced bundle", discount: -2.50)
      combo.products << product_1
      combo.products << product_2

      st1 = StagedPurchase.create(user: user, product: product_1)
      st2 = StagedPurchase.create(user: user, product: product_2)

      expect( combo.satisfied_for?(user.id) ).to be_truthy
    end

    it 'should identify an unsatisfied combo' do
      combo = PriceCombo.create(name: "Reasonably-priced bundle", discount: -2.50)
      combo.products << product_1
      combo.products << product_2

      st1 = StagedPurchase.create(user: user, product: product_1)

      expect( combo.satisfied_for?(user.id) ).to be_falsy
    end

  end

  describe 'total_cart_discount_for' do

    let(:user) { FactoryGirl.create(:user) }

    let(:product_1)   { FactoryGirl.create(:product, title: "The main event", price: 5.00) }
    let(:product_2)   { FactoryGirl.create(:product, title: "Bonus material", price: 3.00) }
    let(:product_3)   { FactoryGirl.create(:product, title: "Some other product", price: 4.00) }
    let(:product_4)   { FactoryGirl.create(:product, title: "Surprise product", price: 2.00) }
    let(:product_5)   { FactoryGirl.create(:product, title: "A sequel no one wants", price: 6.00) }

    let(:staged_purchase)  { FactoryGirl.create(:staged_purchase) }

    it 'should return a discount for one satisfied price combo' do
      combo = PriceCombo.create(name: "Pretty good deal", discount: -2.50)
      combo.products << product_1
      combo.products << product_2

      StagedPurchase.create(user: user, product: product_1)
      StagedPurchase.create(user: user, product: product_2)

      expect( PriceCombo.total_cart_discount_for(user.id) ).to eq(-2.50)

    end

    it 'should return a discount for more than one satisfied price combo' do
      combo1 = PriceCombo.create(name: "Pretty good deal", discount: -2.50)
      combo2 = PriceCombo.create(name: "Amazing deal", discount: -5.25)
      # set up combo 1
      combo1.products << product_1
      combo1.products << product_2
      # set up combo 2
      combo2.products << product_3
      combo2.products << product_4
      combo2.products << product_5

      # fulfill combo 1
      StagedPurchase.create(user: user, product: product_1)
      StagedPurchase.create(user: user, product: product_2)
      # fulfill combo 2
      StagedPurchase.create(user: user, product: product_3)
      StagedPurchase.create(user: user, product: product_4)
      StagedPurchase.create(user: user, product: product_5)

      expect( PriceCombo.total_cart_discount_for(user.id) ).to eq(-7.75)
    end

    it 'should not return any discounts if no price combos satisfied' do
      combo1 = PriceCombo.create(name: "Pretty good deal", discount: -2.50)
      combo2 = PriceCombo.create(name: "Amazing deal", discount: -5.25)
      # set up combo 1
      combo1.products << product_1
      combo1.products << product_2
      # set up combo 2
      combo2.products << product_3
      combo2.products << product_4
      combo2.products << product_5

      StagedPurchase.create(user: user, product: product_1)

      StagedPurchase.create(user: user, product: product_3)
      StagedPurchase.create(user: user, product: product_4)

      expect( PriceCombo.total_cart_discount_for(user.id) ).to eq(0)
    end

  end

end
