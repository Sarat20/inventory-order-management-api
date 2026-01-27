module RequestSpecHelper
  def auth_headers(user)
    post "/api/v1/auth/login",
         params: { email: user.email, password: "password123" },
         headers: { "X-Tenant" => "test_tenant" }

    token = JSON.parse(response.body)["token"]

    {
      "Authorization" => "Bearer #{token}",
      "X-Tenant" => "test_tenant"
    }
  end
end

RSpec.configure do |config|
  config.include RequestSpecHelper, type: :request
end