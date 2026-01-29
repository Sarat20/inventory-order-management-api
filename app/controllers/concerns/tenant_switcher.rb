module TenantSwitcher
  extend ActiveSupport::Concern

  included do
    before_action :switch_tenant
  end

  private

  def switch_tenant
    # In test environment, always switch to a fixed tenant to keep specs simple and isolated
    if Rails.env.test?
      Apartment::Tenant.switch!("test_tenant")
      return
    end

    tenant_name = request.headers["X-Tenant"]

    # Early return style: easier to read and harder to miss
    return render(json: { error: "X-Tenant header missing" }, status: :bad_request) if tenant_name.blank?

    # NOTE:
    # The tenant lookup uses find_by on every request. Consider whether caching valid
    # tenant schema names (even briefly) would reduce database load for high-traffic APIs.
    #
    # We now cache the tenant record for 15 minutes to avoid hitting the DB on every request.
    tenant = Rails.cache.fetch("tenant/#{tenant_name}", expires_in: 15.minutes) do
      Tenant.find_by(schema_name: tenant_name)
    end

    # NOTE:
    # The render ... and return pattern is correct but can be easy to miss when scanning code.
    # We now use a clear early-return style for readability.
    return render(json: { error: "Tenant not found" }, status: :not_found) unless tenant

    # Switch to the tenant schema
    Apartment::Tenant.switch!(tenant.schema_name)
  end
end
