FactoryGirl.define do
  factory :staged_purchase, class: 'Store::StagedPurchase' do
    user
    product
  end

end
