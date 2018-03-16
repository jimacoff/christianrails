require 'rails_helper'

RSpec.describe Store::Download, type: :model do

  let(:product) { FactoryBot.create(:product) }
  let(:release) { FactoryBot.create(:release, product: product) }
  let(:user)    { FactoryBot.create(:user) }

  it "should validate" do
    d = Store::Download.new()
    expect( d ).to_not be_valid
    expect( d.errors.messages.keys ).to include(:release, :user)

    expect( d.errors.messages[:release] ).to include("can't be blank")
    expect( d.errors.messages[:user] ).to include("can't be blank")

    d.release = release
    d.user = user

    expect( d ).to be_valid
  end

  it "should relate to users" do
    d = Store::Download.create(user: user, release: release)
    expect( d.user.id ).to eq(user.id)

    u = d.user
    expect( u.downloads.count ).to eq(1)
  end

  it "should relate to releases" do
    d = Store::Download.create(user: user, release: release)
    expect( d.release.id ).to eq(release.id)

    r = d.release
    expect( r.downloads.count).to eq(1)
  end

  it "should relate to product, through releases" do
    d = Store::Download.create(user: user, release: release)

    expect( d.release ).to eq(release)
    expect( d.release.product ).to eq(product)
  end

end
