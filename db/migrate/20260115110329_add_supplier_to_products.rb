class AddSupplierToProducts < ActiveRecord::Migration[7.0]
  def change
    add_reference :products, :supplier, foreign_key: true, null: true
  end
end
