FactoryBot.define do
  factory :supplier do
    name { "ABC Supplier" }
    email { Faker::Internet.unique.email }
  end
end
