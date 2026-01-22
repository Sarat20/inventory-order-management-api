require "rails_helper"

RSpec.describe "Categories API", type: :request do
  let(:admin) { create(:admin) }

  before do
    post "/api/v1/auth/login", params: { email: admin.email, password: "password123" }
    @token = JSON.parse(response.body)["token"]
  end

  describe "POST /categories" do
    it "creates category" do
      post "/api/v1/categories",
        params: { category: { name: "Electronics" } },
        headers: { "Authorization" => "Bearer #{@token}" }

      body = JSON.parse(response.body)
      expect(body["data"]["name"]).to eq("Electronics")
    end
  end

  describe "GET /categories" do
    it "returns categories" do
      create(:category, name: "Books")

      get "/api/v1/categories", headers: { "Authorization" => "Bearer #{@token}" }

      body = JSON.parse(response.body)
      expect(body["data"].first["name"]).to eq("Books")
    end
  end
end
