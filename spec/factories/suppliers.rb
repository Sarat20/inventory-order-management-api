FactoryBot.define do
  factory :supplier do
    sequence(:name) { |n| "Supplier #{n}" }
    sequence(:email) { |n| "supplier#{n}@test.com" }
  end
end
