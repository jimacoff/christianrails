FactoryBot.define do
  factory :staged_purchase, class: 'Store::StagedPurchase' do
    user
    product
    type_id Store::StagedPurchase::TYPE_DIGITAL_SINGLE
  end

end
