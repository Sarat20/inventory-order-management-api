FactoryBot.define do
  factory :order do
    association :customer
    status { "pending" }

    after(:create) do |order|
      product = create(:product, quantity: 50, price: 100)
      create(:order_item, order: order, product: product, quantity: 2)
    end
  end
end
