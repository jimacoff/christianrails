require 'rails_helper'

RSpec.describe Store::Release, type: :model do

  let(:product)   { FactoryBot.create(:product) }
  let(:user)      { FactoryBot.create(:user) }

  let(:download1) { FactoryBot.create(:download) }
  let(:download2) { FactoryBot.create(:download) }
  let(:download3) { FactoryBot.create(:download) }

  it "validates" do
    r = Store::Release.new()
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

  it "has a valid format" do
    r = Store::Release.create(product: product, format: "JSP", release_date: 1.week.ago)
    expect( r ).to_not be_valid
    expect( r.errors.messages[:format] ).to include("JSP is not a valid format")
  end

  it "has a physical code if it is a book" do
    r = Store::Release.create(product: product, format: "Book", release_date: 1.week.ago)
    expect( r ).to_not be_valid
    expect( r.errors.messages[:physical_code] ).to include("can't be blank")

    r.physical_code = "PHYSICAL"
    expect( r ).to be_valid
  end

  it "belongs to products" do
    r = Store::Release.create(product: product, format: "PDF", release_date: 1.week.ago)
    p = r.product
    expect( p.id ).to eq(product.id)

    rel = p.releases
    expect( rel.count ).to eq(1)
    expect( rel[0] ).to eq(r)
  end

  it "has many downloads" do
    r = Store::Release.create(product: product, format: "PDF", release_date: 1.week.ago)
    r.downloads << download1
    r.downloads << download2
    r.downloads << download3

    expect( r.downloads.count ).to eq(3)
  end
end
