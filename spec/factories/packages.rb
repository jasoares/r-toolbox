FactoryGirl.define do
  sequence(:pkg_name, 'R Package A')
  factory :package do
    name { generate(:pkg_name) }
  end
end
