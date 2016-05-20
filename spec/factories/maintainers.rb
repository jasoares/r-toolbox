FactoryGirl.define do
  factory :maintainer do
    name { Faker::Name.name }
    email { Faker::Internet.free_email(name) }
  end
end
