FactoryBot.define do
  factory :paintball, :class => 'Woods::Paintball' do
    node
    palette

    enabled true
  end

end
