FactoryBot.define do
  factory :product do
    name { "iPhone" }
    price { 1000 }
    quantity { 10 }
    association :category
    association :supplier
  end
end
