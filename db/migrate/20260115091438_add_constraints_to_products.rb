class AddConstraintsToProducts < ActiveRecord::Migration[7.0]
  def change
    change_column_null :products, :price, false
    change_column_null :products, :quantity, false

    add_check_constraint :products, "price > 0", name: "price_must_be_positive"
    add_check_constraint :products, "quantity >= 0", name: "quantity_must_be_non_negative"
  end
end
