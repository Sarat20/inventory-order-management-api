# frozen_string_literal: true

require "apartment/elevators/subdomain"

Apartment.configure do |config|
  # We are using PostgreSQL schemas
  config.use_schemas = true

  # These models should always live in public schema
  config.excluded_models = %w[
    Tenant
    User
  ]

  # Tell Apartment how to find tenant names
  config.tenant_names = -> { Tenant.pluck(:schema_name) }
end

# Enable subdomain based switching (later we will use this)
Rails.application.config.middleware.use Apartment::Elevators::Subdomain
