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

    return render(json: { error: "X-Tenant header missing" }, status: :bad_request) if tenant_name.blank?

    # Cache tenant records for 15 minutes to reduce database load on high-traffic APIs
    tenant = Rails.cache.fetch("tenant/#{tenant_name}", expires_in: 15.minutes) do
      Tenant.find_by(schema_name: tenant_name)
    end

    return render(json: { error: "Tenant not found" }, status: :not_found) unless tenant

    Apartment::Tenant.switch!(tenant.schema_name)
  end
end
