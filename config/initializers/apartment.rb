require "apartment/elevators/subdomain"

Apartment.configure do |config|
  config.use_schemas = true

  config.excluded_models = %w[
    Tenant
  
  ]

  config.tenant_names = -> { Tenant.where.not(schema_name: nil).pluck(:schema_name) }

end

Rails.application.config.middleware.use Apartment::Elevators::Subdomain
