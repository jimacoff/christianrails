FactoryBot.define do
  factory :scorecard, :class => 'Woods::Scorecard' do
    player
    story
    number_of_plays 3
    total_score 103
  end

end
