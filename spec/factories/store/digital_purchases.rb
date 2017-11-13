FactoryGirl.define do
  factory :digital_purchase, class: 'Store::DigitalPurchase' do
    product
    order
    price_cents 3_99
    type_id Store::DigitalPurchase::TYPE_DIGITAL_SINGLE
  end
end
