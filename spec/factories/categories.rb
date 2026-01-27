FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }


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
