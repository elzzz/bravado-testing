FactoryBot.define do
  factory :offer do
    id
    created_at
    price
    company { Faker::Company.name }

    trait :with_departments do
      transient do
        departments_count = 1
      end

      after(:create) do |offer, evaluator|
        create_list(:department, evaluator.departments_count, offers: [offer])
        offer.reload
      end
    end
  end

end