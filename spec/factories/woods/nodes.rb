FactoryGirl.define do
  factory :node, :class => 'Woods::Node' do
    moverule
    storytree

    sequence :name do |n|
      "node_#{n}"
    end
    left_text "Left"
    right_text "Right"
    node_text "Content"

    tree_index 1

  end

end
