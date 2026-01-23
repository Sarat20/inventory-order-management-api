require "rails_helper"

RSpec.describe Api::V1::OrdersController, type: :controller do

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(admin)
  end     
  let(:admin) { create(:admin) }
  let(:order) { create(:order) }

  before do
    sign_in admin
    allow(controller).to receive(:authorize).and_return(true)
  end

  it "lists orders" do
    get :index
    expect(response).to have_http_status(:ok)
  end

  it "shows order" do
    get :show, params: { id: order.id }
    expect(response).to have_http_status(:ok)
  end
end
