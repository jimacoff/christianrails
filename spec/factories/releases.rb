FactoryGirl.define do
  factory :release do
    product
    format "ePub"
    release_date "2015-11-08 22:53:22"
    size "1.4"
    version "First edition"
  end
end
