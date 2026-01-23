require "rails_helper"

RSpec.describe Api::V1::AuthController, type: :controller do
  let(:user) { create(:user, password: "password123") }

  before do
  
    fake_warden = double(
      set_user: true,
      authenticate: true
    )

    allow(request.env).to receive(:[]).and_call_original
    allow(request.env).to receive(:[]).with("warden").and_return(fake_warden)
    allow(request.env).to receive(:[]).with("warden-jwt_auth.token").and_return("fake-jwt-token")
  end

  describe "POST #login" do
    it "logs in with valid credentials" do
      post :login, params: { email: user.email, password: "password123" }

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body["token"]).to be_present
      expect(body["user"]["email"]).to eq(user.email)
    end

    it "fails with invalid credentials" do
      post :login, params: { email: user.email, password: "wrong" }

      expect(response).to have_http_status(:unauthorized)

      body = JSON.parse(response.body)
      expect(body["error"]).to eq("Invalid email or password")
    end
  end

  describe "POST #register" do
    it "creates user" do
      expect {
        post :register, params: {
          name: "Test User",
          email: "test@test.com",
          password: "123456"
        }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end
end
