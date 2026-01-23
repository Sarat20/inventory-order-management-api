require "rails_helper"

RSpec.describe User, type: :model do
  it "is valid" do
    expect(build(:user)).to be_valid
  end

  it "requires email" do
    expect(build(:user, email: nil)).not_to be_valid
  end

  it "requires name" do
    expect(build(:user, name: nil)).not_to be_valid
  end

  it "has roles enum" do
    user = build(:user, role: :admin)
    expect(user.admin?).to eq(true)
  end
end
