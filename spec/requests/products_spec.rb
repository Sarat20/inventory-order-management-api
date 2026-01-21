require "rails_helper"

RSpec.describe "Products API", type: :request do
  let(:admin) { create(:admin) }
  let(:category) { create(:category) }
  let(:supplier) { create(:supplier) }

  let!(:products) { create_list(:product, 3, category: category, supplier: supplier) }

  before do
    post "/api/v1/auth/login", params: { email: admin.email, password: "password123" }
    @token = JSON.parse(response.body)["token"]
  end

  it "returns list of products" do
    get "/api/v1/products", headers: {
      "Authorization" => "Bearer #{@token}"
    }

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["data"].length).to eq(3)
  end
end
