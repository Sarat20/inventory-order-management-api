FactoryBot.define do
  factory :order do
    association :customer
    status { "pending" }

    after(:build) do |order|
      product = create(:product, quantity: 50, price: 100)
      order.order_items.build(product: product, quantity: 2)
    end
  end
end
