require "rails_helper"

RSpec.describe OrderItem, type: :model do
  it "is valid with valid data" do
    order = create(:order)
    product = create(:product)

    item = build(:order_item, order: order, product: product, quantity: 2)
    expect(item).to be_valid
  end

  it "is invalid with quantity <= 0" do
    order = create(:order)
    product = create(:product)

    item = build(:order_item, order: order, product: product, quantity: 0)
    expect(item).not_to be_valid
  end
end
