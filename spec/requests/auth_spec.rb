require "rails_helper"

RSpec.describe "Auth API", type: :request do
  let(:user) { create(:user, password: "password123") }

  describe "POST /login" do
    context "with valid credentials" do
      it "returns token" do
        post "/api/v1/auth/login", params: { email: user.email, password: "password123" }

        body = JSON.parse(response.body)
        expect(body["token"]).to be_present
      end
    end

    context "with invalid credentials" do
      it "returns error" do
        post "/api/v1/auth/login", params: { email: user.email, password: "wrong" }

        body = JSON.parse(response.body)
        expect(body["error"]).to eq("Invalid email or password")
      end
    end
  end

  describe "GET /me" do
    it "returns current user data" do
      post "/api/v1/auth/login", params: { email: user.email, password: "password123" }
      token = JSON.parse(response.body)["token"]

      get "/api/v1/auth/me", headers: { "Authorization" => "Bearer #{token}" }

      body = JSON.parse(response.body)
      expect(body["email"]).to eq(user.email)
    end
  end
end
