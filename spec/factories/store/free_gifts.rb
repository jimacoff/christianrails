FactoryBot.define do
  factory :free_gift, class: 'Store::FreeGift' do
    product
    association :giver, factory: :user
    origin "Just a test thing"
  end
end
