require "rails_helper"

RSpec.describe "Suppliers API", type: :request do
  let(:admin) { create(:admin) }

  before do
    post "/api/v1/auth/login", params: { email: admin.email, password: "password123" }
    @token = JSON.parse(response.body)["token"]
  end

  it "creates supplier" do
    post "/api/v1/suppliers",
      params: { supplier: { name: "ABC", email: "abc@test.com" } },
      headers: { "Authorization" => "Bearer #{@token}" }

    expect(response).to have_http_status(:created)
  end

  it "lists suppliers" do
    create(:supplier)

    get "/api/v1/suppliers",
      headers: { "Authorization" => "Bearer #{@token}" }

    expect(response).to have_http_status(:ok)
  end
end
