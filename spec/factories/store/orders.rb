FactoryBot.define do
  factory :order, class: 'Store::Order' do
    user
    payer_id 'curtis payfield'
    payment_id 'payment-id'
    price_combo
    total_cents 5_99
    shipping_cost_cents 0
    discount_cents 99
    tax_cents 75
  end
end
