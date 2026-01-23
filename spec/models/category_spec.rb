require "rails_helper"

RSpec.describe Category, type: :model do
  it "is valid with valid attributes" do
    category = build(:category)
    expect(category).to be_valid
  end

  it "is invalid without name" do
    category = build(:category, name: nil)
    expect(category).not_to be_valid
  end

  it "enforces unique name" do
    create(:category, name: "Electronics")
    dup = build(:category, name: "Electronics")
    expect(dup).not_to be_valid
  end

  it "has many products" do
    assoc = described_class.reflect_on_association(:products)
    expect(assoc.macro).to eq(:has_many)
  end
end
