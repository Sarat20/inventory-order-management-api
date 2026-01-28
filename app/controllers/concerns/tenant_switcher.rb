module TenantSwitcher
  extend ActiveSupport::Concern

  included do
    before_action :switch_tenant
  end

  private

  def switch_tenant
   
    if Rails.env.test?
      Apartment::Tenant.switch!("test_tenant")
      return
    end

    tenant_name = request.headers["X-Tenant"]
    # NOTE: The tenant lookup uses find_by on every request. Consider whether caching valid
    # tenant schema names (even briefly) would reduce database load for high-traffic APIs.
    tenant = Tenant.find_by(schema_name: tenant_name)

    # NOTE: The render ... and return pattern is correct but can be easy to miss when scanning code.
    # Consider whether an early return style (return render ...) would be clearer.
    render json: { error: "Tenant not found" }, status: :not_found and return unless tenant

    Apartment::Tenant.switch!(tenant.schema_name)
  end
end