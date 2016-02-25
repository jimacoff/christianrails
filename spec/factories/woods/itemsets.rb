FactoryGirl.define do
  factory :itemset, :class => 'Woods::Itemset' do
    player

    sequence :name do |n|
      "itemset_#{n}"
    end
  end

end
