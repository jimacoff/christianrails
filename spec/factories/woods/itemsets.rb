FactoryBot.define do
  factory :itemset, :class => 'Woods::Itemset' do
    story

    sequence :name do |n|
      "itemset_#{n}"
    end
  end

end
