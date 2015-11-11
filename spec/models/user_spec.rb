require "rails_helper"

RSpec.describe User, type: :model do

  let(:product)   { FactoryGirl.create(:product) }

  let(:purchase1) { FactoryGirl.create(:purchase) }
  let(:purchase2) { FactoryGirl.create(:purchase) }
  let(:purchase3) { FactoryGirl.create(:purchase) }
  
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
  

  end

  it "should have many downloads" do


  end

end