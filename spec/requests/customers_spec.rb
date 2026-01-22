require "rails_helper"

RSpec.describe "Customers API", type: :request do
  let(:admin) { create(:admin) }

  before do
    post "/api/v1/auth/login", params: { email: admin.email, password: "password123" }
    @token = JSON.parse(response.body)["token"]
  end

  let(:headers) do
    { "Authorization" => "Bearer #{@token}" }
  end

  describe "POST /customers" do
    it "creates a customer" do
      post "/api/v1/customers",
        params: { customer: { name: "John", email: "john@test.com" } },
        headers: headers

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(body["data"]["name"]).to eq("John")
      expect(Customer.count).to eq(1)
    end
  end

  describe "GET /customers" do
    it "lists customers" do
      create(:customer, name: "Alice", email: "alice@test.com")

      get "/api/v1/customers", headers: headers

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(body["data"].first["name"]).to eq("Alice")
    end
  end

  describe "PUT /customers/:id" do
    it "updates a customer" do
      customer = create(:customer, name: "Old Name")

      put "/api/v1/customers/#{customer.id}",
        params: { customer: { name: "New Name" } },
        headers: headers

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(body["data"]["name"]).to eq("New Name")
      expect(customer.reload.name).to eq("New Name")
    end
  end

  describe "DELETE /customers/:id" do
    it "deletes a customer" do
      customer = create(:customer)

      delete "/api/v1/customers/#{customer.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(Customer.count).to eq(0)
    end
  end
end
