class Tenant < ApplicationRecord
  validates :name, presence: true
  validates :schema_name, presence: true, uniqueness: true

  after_create :create_schema, unless: -> { Rails.env.test? }

  private

  def create_schema
    Apartment::Tenant.create(schema_name)
  rescue Apartment::TenantExists
    # Schema already exists - this is acceptable, just log it
    Rails.logger.warn "Tenant schema already exists: #{schema_name}"
  rescue StandardError => e
    Rails.logger.error "Failed to create tenant schema #{schema_name}: #{e.message}"
    raise ActiveRecord::Rollback
  end
end
