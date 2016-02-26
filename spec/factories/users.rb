FactoryGirl.define do
  factory :user do
    sequence :username do |n|
      "user_#{n}"
    end
    full_name "Ellison Rath"
    country "CA"
    sequence :email do |n|
      "person#{n}@test.com"
    end
    password "it_is_a_word"
    sign_in_count 0
  end
end
