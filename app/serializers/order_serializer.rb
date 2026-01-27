class OrderSerializer < ApplicationSerializer
  attributes :id, :status, :total, :created_at

  one :customer, resource: CustomerSerializer
  many :order_items, resource: OrderItemSerializer
end
