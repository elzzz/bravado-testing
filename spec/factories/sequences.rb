FactoryBot.define do
  sequence(:id) { |n| n }
  sequence(:created_at) { Time.now.utc }
  sequence(:price) { |n| n * 100 }
end