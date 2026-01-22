require "rails_helper"

RSpec.describe "Products API", type: :request do
  let(:admin) { create(:admin) }
  let(:category) { create(:category) }
  let(:supplier) { create(:supplier) }

  before do
    post "/api/v1/auth/login", params: { email: admin.email, password: "password123" }
    @token = JSON.parse(response.body)["token"]
  end

  describe "GET /products" do
    it "returns products" do
      create(:product, name: "iPhone", category: category, supplier: supplier)

      get "/api/v1/products", headers: { "Authorization" => "Bearer #{@token}" }

      body = JSON.parse(response.body)
      expect(body["data"].first["name"]).to eq("iPhone")
    end
  end
end
