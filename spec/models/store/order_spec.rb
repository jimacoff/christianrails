require 'rails_helper'

RSpec.describe Store::Order, type: :model do

  let(:price_combo)  { FactoryGirl.create(:price_combo) }
  let(:purchase1)    { FactoryGirl.create(:purchase) }
  let(:purchase2)    { FactoryGirl.create(:purchase) }

  it "should validate" do
    o = Store::Order.new()
    expect( o ).to_not be_valid
    expect( o.errors.messages.keys ).to include(:payer_id, :payment_id, :total)

    expect( o.errors.messages[:payer_id] ).to include("can't be blank")
    expect( o.errors.messages[:payment_id] ).to include("can't be blank")
    expect( o.errors.messages[:total] ).to include("can't be blank")

    o.payer_id = "jaaaaa"
    o.payment_id = "raaaaa!"
    o.total = 5.33

    expect( o ).to be_valid
  end

  it "should have many purchases" do
    o = Store::Order.create(price_combo: price_combo, payment_id: "ora", payer_id: "arara!", total: 4.65)

    o.purchases << purchase1
    o.purchases << purchase2

    expect( o.purchases.count ).to eq(2)
  end

  it "should belong to price_combo" do
    o = Store::Order.create(price_combo: price_combo, payment_id: "wraa", payer_id: "raaaa!", total: 4.55)

    expect( o.price_combo.id ).to eq(price_combo.id)
  end

end
