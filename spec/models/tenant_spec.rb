require 'rails_helper'

RSpec.describe Tenant, type: :model do
  it "is valid with name and schema_name" do
    tenant = Tenant.new(
      name: "Test Tenant",
      schema_name: "test_tenant"
    )

    expect(tenant).to be_valid
  end

  it "is invalid without a schema_name" do
    tenant = Tenant.new(name: "Test Tenant")

    expect(tenant).not_to be_valid
    expect(tenant.errors[:schema_name]).to include("can't be blank")
  end
end