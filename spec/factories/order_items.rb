FactoryBot.define do
  factory :order_item do
    association :order
    association :product
    quantity { 2 }
    price { nil }

  
    trait :small do
      quantity { 1 }
    end

  
    trait :medium do
      quantity { 5 }
    end

   
    trait :large do
      quantity { 20 }
    end

   
    trait :out_of_stock do
      quantity { 10_000 }
    end
  end
end
