FactoryGirl.define do
  sequence(:version) { |n| "1.#{n}.0" }

  factory :version do
    value { generate(:version) }
    publication { Time.zone.now }
    title 'R Super Package'
    description 'Best package ever'
    authors 'Super Duper R guy'
    association :maintainer, strategy: :build
    association :package, strategy: :build
  end
end
