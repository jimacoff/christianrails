FactoryGirl.define do
  factory :footprint, :class => 'Woods::Footprint' do
    storytree
    scorecard
    footprint_data "xyxyyyx"
  end

end
