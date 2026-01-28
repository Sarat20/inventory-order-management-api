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
    tenant = Tenant.find_by(schema_name: tenant_name)

    render json: { error: "Tenant not found" }, status: :not_found and return unless tenant

    Apartment::Tenant.switch!(tenant.schema_name)
  end
end