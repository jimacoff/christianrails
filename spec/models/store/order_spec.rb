require 'rails_helper'

RSpec.describe Store::Order, type: :model do

  let(:price_combo)       { FactoryGirl.create(:price_combo) }
  let(:digital_purchase1) { FactoryGirl.create(:digital_purchase) }
  let(:digital_purchase2) { FactoryGirl.create(:digital_purchase) }

  it "should validate" do
    o = Store::Order.new()
    expect( o ).to_not be_valid
    expect( o.errors.messages.keys ).to include(:payer_id, :payment_id)

    expect( o.errors.messages[:payer_id] ).to   include("can't be blank")
    expect( o.errors.messages[:payment_id] ).to include("can't be blank")

    o.payer_id = "jaaaaa"
    o.payment_id = "raaaaa!"
    o.total_cents = 5_33

    expect( o ).to be_valid
  end

  it "should have many digital_purchases" do
    o = Store::Order.create(price_combo: price_combo, payment_id: "ora", payer_id: "arara!", total_cents: 4_65)

    o.digital_purchases << digital_purchase1
    o.digital_purchases << digital_purchase2

    expect( o.digital_purchases.count ).to eq(2)
  end

  it "should belong to price_combo" do
    o = Store::Order.create(price_combo: price_combo, payment_id: "wraa", payer_id: "raaaa!", total_cents: 4_55)

    expect( o.price_combo.id ).to eq(price_combo.id)
  end

end
