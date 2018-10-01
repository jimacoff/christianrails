FactoryBot.define do
  factory :nugget, class: 'Nugget' do
    joke "THIS IS A GOOD JOKE"
    access_code "just an access code for the nugget"
    association :unlocked_by, factory: :user
    sequence :serial_number do |n|
      n
    end
  end
end
