class ProductSerializer < ApplicationSerializer
  root_key :product

  prefer_object_method!

  attributes :id, :name, :quantity, :stock_status

  attribute :selling_price, &:display_price

  one :category, resource: CategorySerializer
  one :supplier, resource: SupplierSerializer
end
