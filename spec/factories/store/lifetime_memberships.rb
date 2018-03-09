FactoryGirl.define do
  factory :lifetime_membership, class: 'Store::LifetimeMembership' do
    user
    cost_cents 17_38
  end
end
