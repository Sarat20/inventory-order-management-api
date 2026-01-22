require "rails_helper"

RSpec.describe "Suppliers API", type: :request do
  let(:admin) { create(:admin) }

  before do
    post "/api/v1/auth/login", params: { email: admin.email, password: "password123" }
    @token = JSON.parse(response.body)["token"]
  end

  let(:headers) do
    { "Authorization" => "Bearer #{@token}" }
  end

  describe "POST /suppliers" do
    it "creates supplier" do
      post "/api/v1/suppliers",
        params: { supplier: { name: "ABC", email: "abc@test.com" } },
        headers: headers

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(body["data"]["name"]).to eq("ABC")
      expect(Supplier.count).to eq(1)
    end
  end

  describe "GET /suppliers" do
    it "lists suppliers" do
      create(:supplier, name: "XYZ")

      get "/api/v1/suppliers", headers: headers

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(body["data"].first["name"]).to eq("XYZ")
    end
  end


  describe "PUT /suppliers/:id" do
    it "updates supplier" do
      supplier = create(:supplier, name: "Old Name")

      put "/api/v1/suppliers/#{supplier.id}",
        params: { supplier: { name: "New Name" } },
        headers: headers

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(body["data"]["name"]).to eq("New Name")
      expect(supplier.reload.name).to eq("New Name")
    end
  end

  describe "DELETE /suppliers/:id" do
    it "deletes supplier" do
      supplier = create(:supplier)

      expect {
        delete "/api/v1/suppliers/#{supplier.id}", headers: headers
      }.to change(Supplier, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
