FactoryGirl.define do
  factory :box, :class => 'Woods::Box' do
    itemset
    node

    enabled true
  end

end
