FactoryBot.define do
  factory :item, :class => 'Woods::Item' do
    sequence :name do |n|
      "item_#{n}"
    end
    itemset
    value 10
    legend "Legend of the item"
    image "path_to_image"
    winning_condition false
  end

end
