FactoryGirl.define do
  factory :product, class: 'Store::Product' do
    sequence :title do |n|
      "Book_#{n}"
    end
    author "Authro"
    short_desc "This book is good."
    long_desc "This book is REALLY good."
    price_cents 7_77
    physical_price_cents 10_00
    shipping_cost_cents 0
    rank 1

    giftpackable true
    giftpack_price_cents 14_44
  end
end
