FactoryGirl.define do
  factory :digital_purchase, class: 'Store::DigitalPurchase' do
    product
    order
    price 3.99
  end
end
