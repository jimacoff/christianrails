FactoryGirl.define do
  factory :palette, :class => 'Woods::Palette' do
    player

    sequence :name do |n|
      "palette_#{n}"
    end
    fore_colour "#ffffff"
    back_colour "#000000"
    alt_colour  "#bfbfbf"
  end

end
