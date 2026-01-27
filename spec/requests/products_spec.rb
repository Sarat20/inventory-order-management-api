require "rails_helper"

RSpec.describe "Products API", type: :request do
  let(:admin)    { create(:admin) }
  let(:category) { create(:category, name: "Electronics") }
  let(:supplier) { create(:supplier, name: "ABC Supplier") }
  let(:tenant_headers) { { "X-Tenant" => "test_tenant" } }

  before do
    post "/api/v1/auth/login",
         params: { email: admin.email, password: "password123" },
         headers: tenant_headers

    @token = JSON.parse(response.body)["token"]
  end

  let(:headers) do
    {
      "Authorization" => "Bearer #{@token}",
      "X-Tenant" => "test_tenant"
    }
  end

  describe "GET /products" do
    it "lists products" do
      create(:product, name: "iPhone", category: category, supplier: supplier)

      get "/api/v1/products", headers: headers

      body = JSON.parse(response.body)
      expect(body["data"].first["name"]).to eq("iPhone")
    end
  end

  describe "GET /products/:id" do
    it "shows one product" do
      product = create(:product, name: "MacBook", category: category, supplier: supplier)

      get "/api/v1/products/#{product.id}", headers: headers

      body = JSON.parse(response.body)
      expect(body["data"]["name"]).to eq("MacBook")
    end
  end

  describe "POST /products" do
    it "creates product" do
      post "/api/v1/products",
           params: {
             product: {
               name: "iPad",
               price: 50000,
               quantity: 10,
               category_id: category.id,
               supplier_id: supplier.id
             }
           },
           headers: headers

      product = Product.last
      expect(product.name).to eq("iPad")
    end
  end

  describe "PUT /products/:id" do
    it "updates product" do
      product = create(:product, name: "Old Name", category: category, supplier: supplier)

      put "/api/v1/products/#{product.id}",
          params: { product: { name: "New Name" } },
          headers: headers

      expect(product.reload.name).to eq("New Name")
    end
  end

  describe "DELETE /products/:id" do
    it "deletes product" do
      product = create(:product, category: category, supplier: supplier)

      delete "/api/v1/products/#{product.id}", headers: headers

      expect(Product.exists?(product.id)).to eq(false)
    end
  end
end