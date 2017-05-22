require 'rails_helper'

RSpec.describe Store::StagedPurchase, type: :model do

  let(:product) { FactoryGirl.create(:product, rank: 1) }
  let(:user)    { FactoryGirl.create(:user) }

  it "should validate" do
    sp = Store::StagedPurchase.new
    expect( sp ).to_not be_valid
    expect( sp.errors.messages.keys ).to include(:product, :user)

    expect( sp.errors.messages[:product] ).to include("can't be blank")
    expect( sp.errors.messages[:user] ).to include("can't be blank")

    sp.product = product
    sp.user = user

    expect( sp ).to be_valid
  end

  it "should belong to users" do
    sp = Store::StagedPurchase.create(user: user, product: product)

    expect( sp.user.id ).to eq(user.id)
  end

  it "should belong to products" do
    sp = Store::StagedPurchase.create(user: user, product: product)

    expect( sp.product.id ).to eq(product.id)
  end

  describe "gross_cart_value" do

    let(:product1)  { FactoryGirl.create(:product, price: 2.00) }
    let(:product2)  { FactoryGirl.create(:product, price: 2.40) }
    let(:product3)  { FactoryGirl.create(:product, price: 5.00) }

    let!(:staged_purchase1) { FactoryGirl.create(:staged_purchase, user: user, product: product1) }
    let!(:staged_purchase2) { FactoryGirl.create(:staged_purchase, user: user, product: product2) }
    let!(:staged_purchase3) { FactoryGirl.create(:staged_purchase, user: user, product: product3) }

    it "should get the gross cart value" do
      expect( Store::StagedPurchase.gross_cart_value_for(user.id) ).to eq(9.40)
    end

  end

end
