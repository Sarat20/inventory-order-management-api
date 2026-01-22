require "rails_helper"

RSpec.describe "Customers API", type: :request do
  let(:admin) { create(:admin) }

  before do
    post "/api/v1/auth/login", params: { email: admin.email, password: "password123" }
    @token = JSON.parse(response.body)["token"]
  end

  describe "POST /customers" do
    it "creates customer" do
      post "/api/v1/customers",
        params: { customer: { name: "John", email: "john@test.com" } },
        headers: { "Authorization" => "Bearer #{@token}" }

      body = JSON.parse(response.body)
      expect(body["data"]["name"]).to eq("John")
    end
  end
end
