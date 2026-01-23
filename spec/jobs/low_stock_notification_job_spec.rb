require "rails_helper"

RSpec.describe LowStockNotificationJob, type: :job do
  let(:product) { create(:product, quantity: 2) }

  it "runs without crashing" do
    expect {
      described_class.perform_now(product.id)
    }.not_to raise_error
  end
end
