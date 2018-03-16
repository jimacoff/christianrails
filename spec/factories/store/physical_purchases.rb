FactoryBot.define do
  factory :physical_purchase, class: 'Store::PhysicalPurchase' do
    product
    order
    price_cents 19_99
    type_id Store::PhysicalPurchase::TYPE_PHYSICAL_SINGLE
  end
end
