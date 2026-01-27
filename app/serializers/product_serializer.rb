class ProductSerializer < ApplicationSerializer
  root_key :product

  prefer_object_method!

  attributes :id, :name, :display_price, :quantity, :stock_status

  one :category, resource: CategorySerializer
  one :supplier, resource: SupplierSerializer
end
