FactoryGirl.define do
  factory :possibleitem, :class => 'Woods::Possibleitem' do
    itemset
    node
    enabled true
    perpetual false
  end

end
