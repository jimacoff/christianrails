require 'rails_helper'

RSpec.describe Store::DigitalPurchase, type: :model do

  let(:product) { FactoryGirl.create(:product) }
  let(:order)   { FactoryGirl.create(:order) }

  it "should validate" do
    p = Store::DigitalPurchase.new
    expect( p ).to_not be_valid
    expect( p.errors.messages.keys ).to include(:product, :order)

    expect( p.errors.messages[:product] ).to include("can't be blank")
    expect( p.errors.messages[:order]   ).to include("can't be blank")

    p.product = product
    p.order = order
    p.price_cents = 3_55

    expect( p ).to be_valid
  end

  it "should belong to products" do
    p = Store::DigitalPurchase.create(product: product, order: order)

    expect( p.product.id ).to eq(product.id)
  end

  it "should belong to orders" do
    p = Store::DigitalPurchase.create(product: product, order: order)

    expect( p.order ).to eq(order)
  end

end
