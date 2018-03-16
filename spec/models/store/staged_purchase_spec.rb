require 'rails_helper'

RSpec.describe Store::StagedPurchase, type: :model do

  let(:product) { FactoryBot.create(:product, rank: 1) }
  let(:user)    { FactoryBot.create(:user) }

  it "validates" do
    sp = Store::StagedPurchase.new
    sp.type_id = Store::StagedPurchase::TYPE_DIGITAL_SINGLE
    expect( sp ).to_not be_valid
    expect( sp.errors.messages.keys ).to include(:user)
    expect( sp.errors.messages[:user] ).to include("can't be blank")

    sp.product = product
    sp.user = user

    expect( sp ).to be_valid
  end

  it "belongs to users" do
    sp = Store::StagedPurchase.create(user: user, product: product)

    expect( sp.user.id ).to eq(user.id)
  end

  it "belongs to products" do
    sp = Store::StagedPurchase.create(user: user, product: product)

    expect( sp.product.id ).to eq(product.id)
  end

  describe "gross_cart_value" do

    let(:product1)  { FactoryBot.create(:product, price: 2.00) }
    let(:product2)  { FactoryBot.create(:product, price: 2.40) }
    let(:product3)  { FactoryBot.create(:product, price: 5.00) }

    let!(:staged_purchase1) { FactoryBot.create(:staged_purchase, user: user, product: product1) }
    let!(:staged_purchase2) { FactoryBot.create(:staged_purchase, user: user, product: product2) }
    let!(:staged_purchase3) { FactoryBot.create(:staged_purchase, user: user, product: product3) }

    it "gets the gross cart value" do
      expect( Store::StagedPurchase.gross_cart_value_for(user.id) ).to eq(9_40)
    end

  end

end
