require "rails_helper"

RSpec.describe Customer, type: :model do
  it "is valid with valid attributes" do
    expect(build(:customer)).to be_valid
  end

  it "is invalid without name" do
    expect(build(:customer, name: nil)).not_to be_valid
  end

  it "is invalid without email" do
    expect(build(:customer, email: nil)).not_to be_valid
  end

  it "enforces unique email" do
    create(:customer, email: "a@test.com")
    dup = build(:customer, email: "a@test.com")
    expect(dup).not_to be_valid
  end
end
require "rails_helper"

RSpec.describe Customer, type: :model do
  it "is valid with valid attributes" do
    expect(build(:customer)).to be_valid
  end

  it "is invalid without name" do
    expect(build(:customer, name: nil)).not_to be_valid
  end

  it "is invalid without email" do
    expect(build(:customer, email: nil)).not_to be_valid
  end

  it "enforces unique email" do
    create(:customer, email: "a@test.com")
    dup = build(:customer, email: "a@test.com")
    expect(dup).not_to be_valid
  end
end
