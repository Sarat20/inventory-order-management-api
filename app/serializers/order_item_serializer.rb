class OrderItemSerializer < ApplicationSerializer
  attributes :id, :quantity

  one :product do
    attributes :id, :name, :price
  end
end
