require 'rails_helper'

RSpec.describe Product, type: :model do
  
  let(:release1) { FactoryGirl.create(:release, format: "ePub") }
  let(:release2) { FactoryGirl.create(:release, format: "PDF") }
  
  it "should validate" do
    p = Product.new()
    expect( p ).to_not be_valid
    expect( p.errors.messages.keys ).to include(:title, :author, :price)

    expect( p.errors.messages[:title] ).to include("can't be blank")
    expect( p.errors.messages[:author] ).to include("can't be blank")
    expect( p.errors.messages[:price] ).to include("can't be blank")

    p.title = "Ghostcrime"
    p.author = "Christian DeWolf"
    p.price = 4.99

    expect( p ).to be_valid

  end

  it "should belong to users, through purchases" do
    p = Product.create(title: "Gray", author: "Christian DeWolf", price: 3.99)
    




  end

  it "should have many releases" do
    p = Product.create(title: "Black Ink", author: "Christian DeWolf", price: 9.99)
    p.releases << release1
    p.releases << release2

    expect( p.releases.count ).to eq(2)
  end
  
end
