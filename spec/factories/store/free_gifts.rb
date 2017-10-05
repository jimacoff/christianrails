FactoryGirl.define do
  factory :free_gift, class: 'Store::FreeGift' do
    product
    giver
    origin "Just a test thing"
  end
end
