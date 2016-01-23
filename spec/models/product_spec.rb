require 'rails_helper'

RSpec.describe Product, type: :model do

  let(:release1) { FactoryGirl.create(:release, format: "ePub") }
  let(:release2) { FactoryGirl.create(:release, format: "PDF") }

  let(:user) { FactoryGirl.create(:user) }
  let(:purchase) { FactoryGirl.create(:purchase, user: user) }

  let!(:download1) { FactoryGirl.create(:download, release: release1) }
  let!(:download2) { FactoryGirl.create(:download, release: release1) }
  let!(:download3) { FactoryGirl.create(:download, release: release2) }

  it "should validate" do
    p = Product.new()
    expect( p ).to_not be_valid
    expect( p.errors.messages.keys ).to include(:title, :author, :price)

    expect( p.errors.messages[:title] ).to include("can't be blank")
    expect( p.errors.messages[:author] ).to include("can't be blank")
    expect( p.errors.messages[:price] ).to include("can't be blank")
    expect( p.errors.messages[:rank] ).to include("is not a number")

    p.title = "Ghostcrime"
    p.author = "Christian DeWolf"
    p.price = "Jam"
    p.rank = 1

    expect( p ).to_not be_valid
    expect( p.errors.messages[:price] ).to include("is not a number")

    p.price = 2.33
    expect( p ).to be_valid
  end

  it "should have many releases" do
    p = Product.create(title: "Black Ink", author: "Christian DeWolf", price: 9.99, rank: 1)
    p.releases << release1
    p.releases << release2

    expect( p.releases.count ).to eq(2)
  end

  it "should have many downloads, through releases" do
    p = Product.create(title: "Dream Lawyer", author: "Christian DeWolf", price: 2.99, rank: 4)

    p.releases << release1 << release2

    expect( p.downloads.count ).to eq(3)
    expect( p.downloads ).to include(download1, download2, download3)

  end

  describe 'discount_for' do

    let(:combo)    { FactoryGirl.create(:price_combo, discount: 5.00) }
    let(:product1) { FactoryGirl.create(:product) }
    let(:product2) { FactoryGirl.create(:product) }

    it 'should return a discount for products when user has satisfied price combo' do
      combo.products << product1 << product2
      StagedPurchase.create(user: user, product: product1)
      StagedPurchase.create(user: user, product: product2)

      expect( product1.discount_for(user)).to eq(combo.discount)
      expect( product2.discount_for(user)).to eq(combo.discount)
    end

    it 'should NOT return a discount for products when user has NOT satisfied price combo' do
      combo.products << product1 << product2
      StagedPurchase.create(user: user, product: product1)

      expect( product1.discount_for(user)).to eq(0)
      expect( product1.discount_for(user)).to eq(0)
    end

  end

  describe 'physical and digital helpers' do

    let(:prod1) { FactoryGirl.create(:product) }
    let!(:rel1) { FactoryGirl.create(:release, product: prod1, format: "Book", physical_code: "abcde") }
    let!(:rel2) { FactoryGirl.create(:release, product: prod1, format: "PDF") }
    let!(:rel3) { FactoryGirl.create(:release, product: prod1, format: "ePub") }
    let!(:rel4) { FactoryGirl.create(:release, product: prod1, format: "Kobo") }

    let(:prod2) { FactoryGirl.create(:product) }
    let!(:rel5) { FactoryGirl.create(:release, product: prod2, format: "Book", physical_code: "ABCDE") }

    let(:prod3) { FactoryGirl.create(:product) }
    let!(:rel6) { FactoryGirl.create(:release, product: prod3, format: "PDF") }

    it "should identify all of a product's digital releases" do
      expect( prod1.digital_releases.count ).to eq(3)
      expect( prod1.digital_releases ).to include( rel2, rel3, rel4 )

      expect( prod2.digital_releases.count ).to eq(0)
      expect( prod2.digital_releases ).to eq( [] )

      expect( prod3.digital_releases.count ).to eq(1)
      expect( prod3.digital_releases ).to eq( [ rel6 ] )
    end

    it "should identify if a product has digital releases" do
      expect( prod1.has_digital_release? ).to be_truthy
      expect( prod2.has_digital_release? ).to be_falsy
      expect( prod3.has_digital_release? ).to be_truthy
    end

    it "should identify if a product has physical releases" do
      expect( prod1.has_physical_release? ).to be_truthy
      expect( prod2.has_physical_release? ).to be_truthy
      expect( prod3.has_physical_release? ).to be_falsy
    end

    it "should return a product's physical_code if it has one" do
      expect( prod1.physical_code ).to eq("abcde")
      expect( prod2.physical_code ).to eq("ABCDE")
      expect( prod3.physical_code ).to be_nil
    end

  end

end
