FactoryGirl.define do
  factory :moverule, :class => 'Woods::Moverule' do
    sequence :name do |n|
      "moverule_#{n}"
    end
  end

end
