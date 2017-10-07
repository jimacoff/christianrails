FactoryGirl.define do
  factory :digital_purchase, class: 'Store::DigitalPurchase' do
    product
    order
    price 3.99
    type_id Store::DigitalPurchase::TYPE_DIGITAL_SINGLE
  end
end
