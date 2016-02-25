FactoryGirl.define do
  factory :player, :class => 'Woods::Player' do
    silver_coins 3
    gold_coins 5
    image "path_to_image"
    karma 4
  end

end
