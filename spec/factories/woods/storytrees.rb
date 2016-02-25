FactoryGirl.define do
  factory :storytree, :class => 'Woods::Storytree' do
    story

    max_level 4
    sequence :name do |n|
      "storytree_#{n}"
    end
    deletable false
  end

end
