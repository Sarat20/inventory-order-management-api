require "rails_helper"

RSpec.describe Supplier, type: :model do
  it "is valid" do
    expect(build(:supplier)).to be_valid
  end

  it "requires name" do
    expect(build(:supplier, name: nil)).not_to be_valid
  end

  it "requires email" do
    expect(build(:supplier, email: nil)).not_to be_valid
  end

  it "enforces unique email" do
    create(:supplier, email: "x@test.com")
    dup = build(:supplier, email: "x@test.com")
    expect(dup).not_to be_valid
  end
end
