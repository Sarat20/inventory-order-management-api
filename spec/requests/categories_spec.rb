require "rails_helper"

RSpec.describe "Categories API", type: :request do
  let(:admin) { create(:admin) }

  before do
    post "/api/v1/auth/login", params: { email: admin.email, password: "password123" }
    @token = JSON.parse(response.body)["token"]
  end

  it "creates a category" do
    post "/api/v1/categories",
      params: { category: { name: "Electronics" } },
      headers: { "Authorization" => "Bearer #{@token}" }

    expect(response).to have_http_status(:created)
  end

  it "lists categories" do
    create(:category, name: "Books")

    get "/api/v1/categories",
      headers: { "Authorization" => "Bearer #{@token}" }

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["data"].length).to be >= 1
  end
end
