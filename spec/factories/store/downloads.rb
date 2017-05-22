FactoryGirl.define do
  factory :download, class: 'Store::Download' do
    release
    user
  end
end
