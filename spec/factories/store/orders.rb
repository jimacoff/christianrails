FactoryGirl.define do
  factory :order, class: 'Store::Order' do
    user
    payer_id 'curtis payfield'
    payment_id 'payment-id'
    price_combo
    total 5.99
    discount 0.99
    tax 0.75
  end
end
