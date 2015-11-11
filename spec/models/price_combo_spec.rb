require 'rails_helper'

RSpec.describe PriceCombo, type: :model do

  let(:product_1)   { FactoryGirl.create(:product) }
  let(:product_2)   { FactoryGirl.create(:product) }

  it "should validate" do
    p = PriceCombo.new()
    expect( p ).to_not be_valid
    expect( p.errors.messages.keys ).to include(:name, :price)

    expect( p.errors.messages[:name] ).to include("can't be blank")
    expect( p.errors.messages[:price] ).to include("can't be blank")

    p.name = "Megadeal"
    p.price = 2.99
    expect( p ).to be_valid
  end

  it "should have and belong to many products" do
    p = PriceCombo.create(name: "Cat-related bundle", price: 4.99)
    p.products << product_1
    p.products << product_2

    expect( p.products.count ).to eq(2)
  end
end
