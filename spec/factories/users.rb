FactoryBot.define do
  factory :user do
    id
    name { Faker::Name.name }
    company { Faker::Company.name }

    trait :with_departments do
      transient do
        departments_count { 1 }
      end

      after(:create) do |user, evaluator|
        user.department << create_list(:department, evaluator.departments_count)
        user.reload
      end
    end

    trait :with_best_offers do
      transient do
        perfect_offers_count { 6 }
        good_offers_count { 6 }
        other_offers_count { 6 }
      end

      after(:create) do |user, evaluator|
        create_list(:offer, evaluator.other_offers_count)
        create_list(:offer, evaluator.good_offers_count, company: user.company)
        create_list(:offer, evaluator.perfect_offers_count, company: user.company, department: user.department)
      end
    end

    trait :with_best_api_offers do
      transient do
        perfect_api_offers_count { 2 }
        good_api_offers_count { 2 }
        other_api_offers_count { 2 }
      end

      after(:create) do |user, evaluator|
        create_list(:api_offer, evaluator.other_api_offers_count)
        create_list(:api_offer, evaluator.good_api_offers_count, company: user.company)
        create_list(:api_offer, evaluator.perfect_api_offers_count, company: user.company, department: user.department)
      end
    end

    factory :user_with_offers, traits: [:with_departments, :with_best_offers, :with_best_api_offers]
  end
end