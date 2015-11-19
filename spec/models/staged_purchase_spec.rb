require 'rails_helper'

RSpec.describe StagedPurchase, type: :model do

  let(:product) { FactoryGirl.create(:product, rank: 1) }
  let(:user)    { FactoryGirl.create(:user) }
  
  it "should validate" do
    sp = StagedPurchase.new()
    expect( sp ).to_not be_valid
    expect( sp.errors.messages.keys ).to include(:product, :user)

    expect( sp.errors.messages[:product] ).to include("can't be blank")
    expect( sp.errors.messages[:user] ).to include("can't be blank")

    sp.product = product
    sp.user = user

    expect( sp ).to be_valid
  end

  it "should belong to users" do
    sp = StagedPurchase.create(user: user, product: product)

    expect( sp.user.id ).to eq(user.id)

  end

  it "should belong to products" do
    sp = StagedPurchase.create(user: user, product: product)

    expect( sp.product.id ).to eq(product.id)

  end

end
