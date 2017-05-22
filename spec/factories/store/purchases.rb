FactoryGirl.define do
  factory :purchase, class: 'Store::Purchase' do
    product
    order
    price 3.99
  end
end
