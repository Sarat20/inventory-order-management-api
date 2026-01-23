require "rails_helper"

RSpec.describe Api::V1::CustomersController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(admin)
  end     

  let(:admin) { create(:admin) }

  before do
    sign_in admin
    allow(controller).to receive(:authorize).and_return(true)
  end

  it "lists customers" do
    get :index
    expect(response).to have_http_status(:ok)
  end

  it "creates customer" do
    expect {
      post :create, params: { customer: { name: "John", email: "john@test.com" } }
    }.to change(Customer, :count).by(1)
  end
end
