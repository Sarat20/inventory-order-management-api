require "rails_helper"

RSpec.describe StockMovement, type: :model do
  it "is valid" do
    order = create(:order)
    product = order.products.first

    sm = StockMovement.new(
      product: product,
      reference: order,
      movement_type: "out"
    )

    expect(sm).to be_valid
  end

  it "allows only in or out" do
    order = create(:order)
    product = order.products.first

    sm = StockMovement.new(
      product: product,
      reference: order,
      movement_type: "wrong"
    )

    expect(sm).not_to be_valid
  end
end
