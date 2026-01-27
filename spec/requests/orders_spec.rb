require "rails_helper"

RSpec.describe "Orders API", type: :request do
  let(:admin)    { create(:admin) }
  let(:customer) { create(:customer) }
  let(:product)  { create(:product, quantity: 10, price: 100) }
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

  context "POST /orders" do
    it "creates an order with items" do
      post "/api/v1/orders",
           params: {
             order: {
               customer_id: customer.id,
               order_items_attributes: [
                 { product_id: product.id, quantity: 2 }
               ]
             }
           },
           headers: headers

      body = JSON.parse(response.body)

      expect(body["data"]["id"]).to be_present
      expect(Order.count).to eq(1)
      expect(OrderItem.count).to eq(1)
    end

    it "does not allow creating order without items" do
      post "/api/v1/orders",
           params: { order: { customer_id: customer.id } },
           headers: headers

      expect(Order.count).to eq(0)
    end

    it "allows creating order even if quantity is more than stock (checked on confirm)" do
      post "/api/v1/orders",
           params: {
             order: {
               customer_id: customer.id,
               order_items_attributes: [
                 { product_id: product.id, quantity: 100 }
               ]
             }
           },
           headers: headers

      expect(Order.count).to eq(1)
    end
  end

  context "Order state transitions" do
    let!(:order) do
      post "/api/v1/orders",
           params: {
             order: {
               customer_id: customer.id,
               order_items_attributes: [
                 { product_id: product.id, quantity: 2 }
               ]
             }
           },
           headers: headers

      Order.last
    end

    it "confirms an order" do
      post "/api/v1/orders/#{order.id}/confirm", headers: headers
      expect(order.reload.status).to eq("confirmed")
    end

    it "ships an order" do
      post "/api/v1/orders/#{order.id}/confirm", headers: headers
      post "/api/v1/orders/#{order.id}/ship", headers: headers

      expect(order.reload.status).to eq("shipped")
    end

    it "cancels an order" do
      post "/api/v1/orders/#{order.id}/cancel", headers: headers
      expect(order.reload.status).to eq("cancelled")
    end
  end

  context "Stock management" do
    it "reduces product stock when order is confirmed" do
      post "/api/v1/orders",
           params: {
             order: {
               customer_id: customer.id,
               order_items_attributes: [
                 { product_id: product.id, quantity: 3 }
               ]
             }
           },
           headers: headers

      order = Order.last
      initial_stock = product.quantity

      post "/api/v1/orders/#{order.id}/confirm", headers: headers

      expect(product.reload.quantity).to eq(initial_stock - 3)
    end

    it "fails to confirm if stock is insufficient" do
      post "/api/v1/orders",
           params: {
             order: {
               customer_id: customer.id,
               order_items_attributes: [
                 { product_id: product.id, quantity: 100 }
               ]
             }
           },
           headers: headers

      order = Order.last

      post "/api/v1/orders/#{order.id}/confirm", headers: headers

      expect(order.reload.status).to eq("pending")
    end
  end
end