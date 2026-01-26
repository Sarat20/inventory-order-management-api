class ProductSerializer < ApplicationSerializer
  root_key :product
  attributes :id, :name, :price, :quantity

  one :category, resource: CategorySerializer
  one :supplier, resource: SupplierSerializer
end
