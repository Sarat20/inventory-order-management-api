FactoryBot.define do
  factory :product do
    name { "Test Product" }
    price { 100 }
    quantity { 10 }
    association :category
    association :supplier
  end
end
