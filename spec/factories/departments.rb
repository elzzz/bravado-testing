FactoryBot.define do
  factory :department do
    id
    name { Faker::Commerce.department(max: 2) }
  end
end