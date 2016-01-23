require 'rails_helper'

RSpec.describe Purchase, type: :model do

  let(:product) { FactoryGirl.create(:product) }
  let(:order)   { FactoryGirl.create(:order) }

  it "should validate" do
    p = Purchase.new()
    expect( p ).to_not be_valid
    expect( p.errors.messages.keys ).to include(:product, :order, :price)

    expect( p.errors.messages[:product] ).to include("can't be blank")
    expect( p.errors.messages[:order] ).to include("can't be blank")
    expect( p.errors.messages[:price] ).to include("can't be blank")

    p.product = product
    p.order = order
    p.price = 3.55

    expect( p ).to be_valid
  end

  it "should belong to products" do
    p = Purchase.create(product: product, order: order)

    expect( p.product.id ).to eq(product.id)
  end

  it "should belong to orders" do
    p = Purchase.create(product: product, order: order)

    expect( p.order ).to eq(order)
  end

end
