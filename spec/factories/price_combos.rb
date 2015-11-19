FactoryGirl.define do
  factory :price_combo do
    sequence :name do |n|
      "Combo_#{n}"
    end
    discount "-1.00"
  end
end
