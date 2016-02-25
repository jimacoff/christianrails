FactoryGirl.define do
  factory :story, :class => 'Woods::Story' do
    player

    sequence :name do |n|
      "story_#{n}"
    end
    published true
  end

end
