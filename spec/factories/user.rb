FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@test.com"
    end
    encrypted_password "Test_pass"
    sign_in_count 0
  end
end