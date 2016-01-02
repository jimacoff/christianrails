require 'rails_helper'

RSpec.describe Release, type: :model do

  let(:product)   { FactoryGirl.create(:product) }
  let(:user)      { FactoryGirl.create(:user) }

  let(:download1) { FactoryGirl.create(:download) }
  let(:download2) { FactoryGirl.create(:download) }
  let(:download3) { FactoryGirl.create(:download) }

  it "should validate" do
    r = Release.new()
    expect( r ).to_not be_valid
    expect( r.errors.messages.keys ).to include(:product, :format, :release_date)

    expect( r.errors.messages[:product] ).to include("can't be blank")
    expect( r.errors.messages[:format] ).to include("can't be blank")
    expect( r.errors.messages[:release_date] ).to include("can't be blank")

    r.product = product
    r.format = "ePub"
    r.release_date = 1.day.ago

    expect( r ).to be_valid
  end

  it "should have a valid format" do
    r = Release.create(product: product, format: "JSP", release_date: 1.week.ago)
    expect( r ).to_not be_valid
    expect( r.errors.messages[:format] ).to include("JSP is not a valid format")
  end

  it "should have a physical code if it is a book" do
    r = Release.create(product: product, format: "Book", release_date: 1.week.ago)
    expect( r ).to_not be_valid
    expect( r.errors.messages[:physical_code] ).to include("can't be blank")

    r.physical_code = "PHYSICAL"
    expect( r ).to be_valid
  end

  it "should belong to products" do
    r = Release.create(product: product, format: "PDF", release_date: 1.week.ago)
    p = r.product
    expect( p.id ).to eq(product.id)

    rel = p.releases
    expect( rel.count ).to eq(1)
    expect( rel[0] ).to eq(r)
  end

  it "should have many downloads" do
    r = Release.create(product: product, format: "PDF", release_date: 1.week.ago)
    r.downloads << download1
    r.downloads << download2
    r.downloads << download3

    expect( r.downloads.count ).to eq(3)
  end
end
