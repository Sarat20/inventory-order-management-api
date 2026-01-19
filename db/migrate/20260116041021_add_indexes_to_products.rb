class AddIndexesToProducts < ActiveRecord::Migration[7.0]
  def change
    add_index :products, :category_id, if_not_exists: true
    add_index :products, :supplier_id, if_not_exists: true
    add_index :products, :quantity, if_not_exists: true
  end
end
