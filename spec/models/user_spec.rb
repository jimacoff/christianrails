require "rails_helper"

RSpec.describe User, type: :model do

  let(:product)   { FactoryGirl.create(:product, title: "Hella product") }

  let(:purchase1) { FactoryGirl.create(:purchase, product: product) }
  let(:purchase2) { FactoryGirl.create(:purchase) }
  let(:purchase3) { FactoryGirl.create(:purchase) }
  
  let(:download1) { FactoryGirl.create(:download) }
  let(:download2) { FactoryGirl.create(:download) }
  let(:download3) { FactoryGirl.create(:download) }

  it "should validate" do
    u = User.new()
    expect( u ).to_not be_valid
    expect( u.errors.messages.keys ).to include(:username, :full_name, :country)
    expect( u.errors.messages.keys ).to include(:email, :encrypted_password)
    
    expect( u.errors.messages[:username] ).to include("can't be blank")
    expect( u.errors.messages[:full_name] ).to include("can't be blank")
    expect( u.errors.messages[:country] ).to include("can't be blank")
    expect( u.errors.messages[:email] ).to include("can't be blank")
    expect( u.errors.messages[:encrypted_password] ).to include("can't be blank")

    u.username = "keazy"
    u.full_name = "Kevin"
    u.country = "US"
    u.email = "cinnabon@themall.com"
    u.password = "kevs_pass"

    expect( u ).to be_valid
  end

  it "should have many purchases" do
    u = User.create(username: "Tim", full_name: "Tim", country: "CA", email: "tim@test.com", password: "timsword")
  
    expect( u.purchases.count ).to eq(0)

    u.purchases << purchase1
    u.purchases << purchase2
    u.purchases << purchase3

    expect( u.purchases.count ).to eq(3)
  end

  it "should have products through purchases" do
    u = User.create(username: "Tim", full_name: "Tim", country: "CA", email: "tim@test.com", password: "timsword")
    
    expect( u.products.count ).to eq(0)

    u.purchases << purchase1

    expect( u.products.count ).to eq(1)
    expect( u.products[0].title ).to include("Hella")
  end

  it "should have many downloads" do
    u = User.create(username: "Tim", full_name: "Tim", country: "CA", email: "tim@test.com", password: "timsword")
    
    expect( u.downloads.count ).to eq(0)

    u.downloads << download1
    u.downloads << download2
    u.downloads << download3

    expect( u.downloads.count ).to eq(3)
  end

  describe "has_product?" do

  let(:product1)   { FactoryGirl.create(:product, title: "Sick product") }
  let(:product2)   { FactoryGirl.create(:product, title: "Rad product") }

  let(:purchase) { FactoryGirl.create(:purchase, product: product1) }

    it 'should return true when user has purchased product, false otherwise' do
      u = User.create(username: "Jonn", full_name: "Jonn", country: "CA", email: "jonn@test.com", password: "jonnsword")
    
      u.purchases << purchase

      expect( u.has_product?(product1.id) ).to be_truthy
      expect( u.has_product?(product2.id) ).to be_falsy
    end

  end

end