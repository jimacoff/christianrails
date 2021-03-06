require "rails_helper"

RSpec.describe User, type: :model do

  let(:product) { FactoryBot.create(:product, title: "Hella product", rank: 1) }

  let(:order) { FactoryBot.create(:order) }

  let!(:digital_purchase1) { FactoryBot.create(:digital_purchase, order: order, product: product) }
  let!(:digital_purchase2) { FactoryBot.create(:digital_purchase, order: order) }
  let!(:digital_purchase3) { FactoryBot.create(:digital_purchase, order: order) }

  let(:download1) { FactoryBot.create(:download) }
  let(:download2) { FactoryBot.create(:download) }
  let(:download3) { FactoryBot.create(:download) }

  let(:staged1) { FactoryBot.create(:staged_purchase) }
  let(:staged2) { FactoryBot.create(:staged_purchase) }
  let(:staged3) { FactoryBot.create(:staged_purchase) }


  it "validates" do
    u = User.new()
    expect( u ).to_not be_valid
    expect( u.errors.messages.keys ).to include(:username, :first_name, :last_name)
    expect( u.errors.messages.keys ).to include(:email, :encrypted_password)

    expect( u.errors.messages[:username] ).to include("can't be blank")
    expect( u.errors.messages[:first_name] ).to include("can't be blank")
    expect( u.errors.messages[:last_name] ).to include("can't be blank")
    expect( u.errors.messages[:email] ).to include("can't be blank")
    expect( u.errors.messages[:encrypted_password] ).to include("can't be blank")

    u.username = "keazy"
    u.first_name = "Kevin"
    u.last_name = "K"
    u.country = "US"
    u.email = "cinnabon@themall.com"
    u.password = "kevs_pass"

    expect( u ).to be_valid
  end

  it "has many orders" do
    u = User.create(username: "Tim", first_name: "Tim", last_name: "Test", country: "CA", email: "tim@test.com", password: "timsword")

    expect( u.orders.count ).to eq(0)

    order.user = u
    order.save

    expect( u.orders.count ).to eq(1)
  end

  it "has many digital_purchases through orders" do
    u = User.create(username: "Tim", first_name: "Tim", last_name: "Test", country: "CA", email: "tim@test.com", password: "timsword")

    order.user = u
    order.save

    expect( u.digital_purchases.count ).to eq(3)
  end

  it "has many downloads" do
    u = User.create(username: "Tim", first_name: "Tim", last_name: "Test", country: "CA", email: "tim@test.com", password: "timsword")

    expect( u.downloads.count ).to eq(0)

    u.downloads << download1
    u.downloads << download2
    u.downloads << download3

    expect( u.downloads.count ).to eq(3)
  end

  it "has many staged purchases" do
    u = User.create(username: "Tim", first_name: "Tim", last_name: "Test", country: "CA", email: "tim@test.com", password: "timsword")

    expect( u.staged_purchases.count ).to eq(0)

    u.staged_purchases << staged1
    u.staged_purchases << staged2
    u.staged_purchases << staged3

    expect( u.staged_purchases.count ).to eq(3)
  end

  describe "product helpers" do

    let(:user_who_buys) { FactoryBot.create(:user) }

    let(:product1) { FactoryBot.create(:product, title: "Sick product") }
    let(:product2) { FactoryBot.create(:product, title: "Rad product") }
    let(:product3) { FactoryBot.create(:product, title: "Lame product") }

    let(:order1)   { FactoryBot.create(:order, user: user_who_buys) }

    let!(:digital_purchase1) { FactoryBot.create(:digital_purchase, order: order1, product: product1) }
    let!(:digital_purchase2) { FactoryBot.create(:digital_purchase, order: order1, product: product2) }

    let(:loyal_user) { FactoryBot.create(:user) }
    let!(:lifetime_membership) { FactoryBot.create(:lifetime_membership, user: loyal_user) }

    describe "products" do

      it "gets all the products the user has purchased" do
        expect( user_who_buys.products.count ).to eq(2)
        expect( user_who_buys.products ).to include(product1, product2)
      end

    end

    describe "has_product?" do

      it 'returns true when user has purchased product, false otherwise' do
        expect( user_who_buys.has_product?(product1.id) ).to be_truthy
        expect( user_who_buys.has_product?(product2.id) ).to be_truthy
        expect( user_who_buys.has_product?(product3.id) ).to be_falsy
      end

      it "returns true if the user has a lifetime lifetime_membership" do
        expect( loyal_user.has_product?(product1.id) ).to be_truthy
        expect( loyal_user.has_product?(product2.id) ).to be_truthy
        expect( loyal_user.has_product?(product3.id) ).to be_truthy
      end

    end

  end

end
