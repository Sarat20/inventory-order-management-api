RSpec.configure do |config|
  config.before(:suite) do
    begin
      Apartment::Tenant.create("test_tenant")
    rescue Apartment::TenantExists
      # ignore
    end
  end

  config.before(:each) do
    Apartment::Tenant.switch!("test_tenant")
  end

  config.after(:each) do
    Apartment::Tenant.reset
  end
end
