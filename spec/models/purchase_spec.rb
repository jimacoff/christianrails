require 'rails_helper'

RSpec.describe Purchase, type: :model do

  let(:product) { FactoryGirl.create(:product) }
  let(:user)    { FactoryGirl.create(:user) }
  
  it "should validate" do
    p = Purchase.new()
    expect( p ).to_not be_valid
    expect( p.errors.messages.keys ).to include(:product, :user)

    expect( p.errors.messages[:product] ).to include("can't be blank")
    expect( p.errors.messages[:user] ).to include("can't be blank")

    p.product = product
    p.user = user

    expect( p ).to be_valid
  end

  it "should belong to users" do
    p = Purchase.create(user: user, product: product)

    expect( p.user.id ).to eq(user.id)

  end

  it "should belong to products" do
    p = Purchase.create(user: user, product: product)

    expect( p.product.id ).to eq(product.id)

  end
  
end
