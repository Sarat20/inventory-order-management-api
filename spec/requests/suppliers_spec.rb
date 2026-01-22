require "rails_helper"

RSpec.describe "Suppliers API", type: :request do
  let(:admin) { create(:admin) }

  before do
    post "/api/v1/auth/login", params: { email: admin.email, password: "password123" }
    @token = JSON.parse(response.body)["token"]
  end

  describe "POST /suppliers" do
    it "creates supplier" do
      post "/api/v1/suppliers",
        params: { supplier: { name: "ABC", email: "abc@test.com" } },
        headers: { "Authorization" => "Bearer #{@token}" }

      body = JSON.parse(response.body)
      expect(body["data"]["name"]).to eq("ABC")
    end
  end

  describe "GET /suppliers" do
    it "lists suppliers" do
      create(:supplier, name: "XYZ")

      get "/api/v1/suppliers", headers: { "Authorization" => "Bearer #{@token}" }

      body = JSON.parse(response.body)
      expect(body["data"].first["name"]).to eq("XYZ")
    end
  end
end
