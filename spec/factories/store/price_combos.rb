FactoryGirl.define do
  factory :price_combo, class: 'Store::PriceCombo' do
    sequence :name do |n|
      "Combo_#{n}"
    end
    discount_cents -1_00
  end
end
