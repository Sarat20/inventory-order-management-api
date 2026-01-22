FactoryBot.define do
  factory :order do
    association :customer

    after(:create) do |order|
      product = create(:product, quantity: 10)
      create(:order_item, order: order, product: product, quantity: 2)
    end
  end
end
