require 'rails_helper'

RSpec.describe Store::FreeGift, type: :model do

  let(:product)   { FactoryGirl.create(:product) }
  let(:recipient) { FactoryGirl.create(:user) }
  let(:giver)     { FactoryGirl.create(:user) }

  it "can be given to another user" do
    fg = Store::FreeGift.create(giver: giver, recipient: recipient, product: product, origin: "Just a test")

    expect( fg.recipient ).to eq(recipient)
    expect( fg.giver ).to eq(giver)
    expect( fg.product ).to eq(product)
    expect( fg.given? ).to eq(true)

    fg.recipient = nil
    expect( fg.save   ).to eq(true)
    expect( fg.given? ).to eq(false)
  end

end
