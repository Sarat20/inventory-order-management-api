FactoryBot.define do
  factory :stock_movement do
    association :product
    association :reference, factory: :order
    movement_type { "out" }
    quantity { 2 }
  end
end
