require "rails_helper"

RSpec.describe "Categories API", type: :request do
  let(:admin) { create(:admin) }

  before do
    post "/api/v1/auth/login", params: { email: admin.email, password: "password123" }
    @token = JSON.parse(response.body)["token"]
  end

  let(:headers) do
    { "Authorization" => "Bearer #{@token}" }
  end

  describe "POST /categories" do
    it "creates a category" do
      post "/api/v1/categories",
        params: { category: { name: "Electronics" } },
        headers: headers

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(body["data"]["name"]).to eq("Electronics")
      expect(Category.count).to eq(1)
    end
  end

  describe "GET /categories" do
    it "lists categories" do
      create(:category, name: "Books")

      get "/api/v1/categories", headers: headers

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(body["data"].first["name"]).to eq("Books")
    end
  end

  describe "PUT /categories/:id" do
    it "updates a category" do
      category = create(:category, name: "Old Name")

      put "/api/v1/categories/#{category.id}",
        params: { category: { name: "New Name" } },
        headers: headers

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(body["data"]["name"]).to eq("New Name")
      expect(category.reload.name).to eq("New Name")
    end
  end

  describe "DELETE /categories/:id" do
    it "deletes a category" do
      category = create(:category)

      delete "/api/v1/categories/#{category.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(Category.count).to eq(0)
    end
  end
end
