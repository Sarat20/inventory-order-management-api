class Product < ApplicationRecord
    belongs_to :category
    belongs_to :supplier

    validates :name, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

    scope :price_greater_than, ->(amount) { where("price > ?", amount) }
    scope :price_less_than,    ->(amount) { where("price < ?", amount) }
    scope :in_stock,           -> { where("quantity > 0") }
    scope :by_category,        ->(category_id) { where(category_id: category_id) }
end
