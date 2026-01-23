class ProductSerializer < ApplicationSerializer
  attributes :id, :name, :price, :quantity

  one :category, resource: CategorySerializer
  one :supplier, resource: SupplierSerializer
end
