require "rails_helper"

RSpec.describe Api::V1::ProductsController, type: :controller do

   
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(admin)
  end   
  let(:admin) { create(:admin) }
  let(:category) { create(:category) }
  let(:supplier) { create(:supplier) }
  let!(:product) { create(:product, category: category, supplier: supplier) }

  before do
    sign_in admin
    allow(controller).to receive(:authorize).and_return(true)
  end

  it "lists products" do
    get :index
    expect(response).to have_http_status(:ok)
  end

  it "creates product" do
    expect {
      post :create, params: {
        product: {
          name: "New",
          price: 100,
          quantity: 5,
          category_id: category.id,
          supplier_id: supplier.id
        }
      }
    }.to change(Product, :count).by(1)
  end
end
