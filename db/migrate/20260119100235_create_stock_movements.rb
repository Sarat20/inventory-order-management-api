class CreateStockMovements < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_movements do |t|
      t.references :reference, polymorphic: true, null: false
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.string :movement_type

      t.timestamps
    end
  end
end
