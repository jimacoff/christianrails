FactoryGirl.define do
  factory :purchase do
    product
    user
    order
    price 3.99
  end
end
