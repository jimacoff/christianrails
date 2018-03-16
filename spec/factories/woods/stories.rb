FactoryBot.define do
  factory :story, :class => 'Woods::Story' do
    player
    sequence :name do |n|
      "story_#{n}"
    end
    published true
    allow_remote_syncing true
  end

end
