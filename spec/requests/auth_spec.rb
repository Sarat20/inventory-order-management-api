require "rails_helper"

RSpec.describe "Auth API", type: :request do
  let(:user) { create(:user, password: "password123") }

  describe "POST /auth/login" do
    context "with valid credentials" do
      it "returns token" do
        post "/api/v1/auth/login", params: { email: user.email, password: "password123" }

        body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(body["token"]).to be_present
      end
    end

    context "with invalid credentials" do
      it "returns error" do
        post "/api/v1/auth/login", params: { email: user.email, password: "wrong" }

        body = JSON.parse(response.body)

        expect(response).to have_http_status(:unauthorized)
        expect(body["error"]).to eq("Invalid email or password")
      end
    end
  end

  describe "GET /auth/me" do
    it "returns current user data" do
      post "/api/v1/auth/login", params: { email: user.email, password: "password123" }
      token = JSON.parse(response.body)["token"]

      get "/api/v1/auth/me", headers: { "Authorization" => "Bearer #{token}","X-Tenant" => "test_tenant"}

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(body["email"]).to eq(user.email)
    end
  end

  describe "DELETE /auth/logout" do
    it "logs out the user and invalidates token" do
     
      post "/api/v1/auth/login", params: { email: user.email, password: "password123" }
      token = JSON.parse(response.body)["token"]

      delete "/api/v1/auth/logout", headers: { "Authorization" => "Bearer #{token}","X-Tenant" => "test_tenant" }

      expect(response).to have_http_status(:ok)

      get "/api/v1/auth/me", headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
