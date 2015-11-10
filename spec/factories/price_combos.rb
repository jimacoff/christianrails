FactoryGirl.define do
  factory :price_combo do
    sequence :name do |n|
      "Combo_#{n}"
    end
    price "5.00"
  end

end
