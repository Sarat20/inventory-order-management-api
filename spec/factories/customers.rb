FactoryBot.define do
  factory :customer do
    name { "John" }
    email { Faker::Internet.email }
  end
end
