FactoryBot.define do
  factory :treelink, class: 'Woods::Treelink' do
    node
    association :linked_tree, factory: :storytree

    enabled true
  end

end
