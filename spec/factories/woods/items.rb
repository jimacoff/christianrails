FactoryGirl.define do
  factory :item, :class => 'Woods::Item' do
    itemset

    sequence :name do |n|
      "item_#{n}"
    end
    value 10
    legend "Legend of the item"
    image "path_to_image"
  end

end
