FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }

    trait :electronics do
      name { "Electronics" }
    end

    trait :groceries do
      name { "Groceries" }
    end

    trait :books do
      name { "Books" }
    end
  end
end
