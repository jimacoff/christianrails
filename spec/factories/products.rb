FactoryGirl.define do
  factory :product do
    sequence :title do |n|
      "Book_#{n}"
    end
    author "Authro"
    short_desc "This book is good."
    long_desc "This book is REALLY good."
    price "7.77"
  end

end
