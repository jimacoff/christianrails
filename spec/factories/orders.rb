FactoryGirl.define do
  factory :order do
    payer_id 'curtis payfield'
    payment_id 'payment-id'
    price_combo
    total 5.99
    discount 0.99
    tax 1.22
  end
end
