require "rails_helper"

RSpec.describe Order, type: :model do
  let(:order) { create(:order) }

  it "is valid" do
    expect(order).to be_valid
  end

  it "must have at least one item" do
    empty_order = build(:order)
    empty_order.order_items.clear

    expect(empty_order).not_to be_valid
  end

  it "starts in pending state" do
    expect(order.status).to eq("pending")
  end

  it "confirms when stock is available" do
    expect(order.may_confirm?).to eq(true)
    order.confirm!
    expect(order.status).to eq("confirmed")
  end

  it "reduces product stock on confirm" do
    product = order.products.first
    initial_qty = product.quantity

    order.confirm!

    expect(product.reload.quantity).to eq(initial_qty - 2)
  end
end
