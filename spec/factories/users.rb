FactoryGirl.define do
  factory :user do
    sequence :username do |n|
      "user_#{n}"
    end
    first_name "Ellison"
    last_name "Rath"
    country "CA"
    sequence :email do |n|
      "person#{n}@test.com"
    end
    password "it_is_a_word"
    sign_in_count 0
    last_gift_nudge nil
  end
end
