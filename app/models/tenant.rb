class Tenant < ApplicationRecord
  validates :name, presence: true
  validates :schema_name, presence: true, uniqueness: true

  after_create :create_schema, unless: -> { Rails.env.test? }
  private

  def create_schema
    Apartment::Tenant.create(schema_name)
  rescue Apartment::TenantExists
    # NOTE: This exception is intentionally swallowed. Consider logging this scenario
    # or adding a comment explaining why this is acceptable behavior.
  end
end
