require "rails_helper"

RSpec.describe Api::V1::CategoriesController, type: :controller do
 
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(admin)
  end 
  let(:admin) { create(:admin) }

  let!(:category) { create(:category) }

  before do
    sign_in admin
    allow(controller).to receive(:authorize).and_return(true)
  end

  it "lists categories" do
    get :index
    expect(response).to have_http_status(:ok)
  end

  it "creates category" do
    expect {
      post :create, params: { category: { name: "NewCat" } }
    }.to change(Category, :count).by(1)
  end
end
