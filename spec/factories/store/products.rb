FactoryGirl.define do
  factory :product, class: 'Store::Product' do
    sequence :title do |n|
      "Book_#{n}"
    end
    author "Authro"
    short_desc "This book is good."
    long_desc "This book is REALLY good."
    price 7.77
    rank 1
  end
end