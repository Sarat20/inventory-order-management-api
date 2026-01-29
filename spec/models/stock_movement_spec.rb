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

  it "raises error for invalid movement_type" do
    order = create(:order)
    product = order.products.first

    expect {
      StockMovement.new(
        product: product,
        reference: order,
        movement_type: "wrong"
      )
    }.to raise_error(ArgumentError)
  end
end
