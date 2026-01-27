FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Test Product #{n}" }
    price { 100 }
    quantity { 10 }
    association :category
    association :supplier
  end
end
