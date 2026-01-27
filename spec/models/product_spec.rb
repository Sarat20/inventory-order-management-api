require "rails_helper"

RSpec.describe Product, type: :model do
  it "is valid" do
    expect(build(:product)).to be_valid
  end

  it "requires name" do
    expect(build(:product, name: nil)).not_to be_valid
  end

  it "requires price > 0" do
    expect(build(:product, price: -1)).not_to be_valid
  end

  it "requires quantity >= 0" do
    expect(build(:product, quantity: -1)).not_to be_valid
  end

  it "belongs to category" do
    expect(Product.reflect_on_association(:category).macro).to eq(:belongs_to)
  end

  it "belongs to supplier" do
    expect(Product.reflect_on_association(:supplier).macro).to eq(:belongs_to)
  end
end
