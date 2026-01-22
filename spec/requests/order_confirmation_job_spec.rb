require "rails_helper"

RSpec.describe OrderConfirmationJob, type: :job do
  let(:customer) { create(:customer) }
  let(:product)  { create(:product, quantity: 10, price: 100) }

  let(:order) do
    Order.create!(
      customer: customer,
      order_items_attributes: [
        { product_id: product.id, quantity: 2 }
      ]
    )
  end

  it "runs without crashing" do
    expect {
      described_class.perform_now(order.id)
    }.not_to raise_error
  end
end
