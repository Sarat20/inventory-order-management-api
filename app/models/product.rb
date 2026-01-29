class Product < ApplicationRecord
  audited

  belongs_to :category
  belongs_to :supplier

  # NOTE: This association lacks a dependent option. Consider whether orphaned stock_movements
  # should be destroyed, nullified, or restricted when a product is deleted.

  has_many :stock_movements, dependent: :restrict_with_error

  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :price_greater_than, ->(amount) { where("price > ?", amount) }
  scope :price_less_than,    ->(amount) { where(price: ...amount) }
  scope :in_stock,           -> { where("quantity > 0") }
  scope :by_category,        ->(category_id) { where(category_id: category_id) }

  after_commit :check_low_stock, on: :update
  after_commit :invalidate_cache

  # NOTE: The low stock threshold (5) was hardcoded earlier.
  # We have now extracted it to a constant to avoid duplication and make future changes easy.
  LOW_STOCK_THRESHOLD = 5

  def display_price
    "₹#{price}"
  end

  def stock_status
    quantity > 0 ? "In Stock" : "Out of Stock"
  end

  def low_stock?
    quantity < LOW_STOCK_THRESHOLD
  end


  def check_low_stock
    if saved_change_to_quantity? &&
       quantity < LOW_STOCK_THRESHOLD &&
       quantity_before_last_save >= LOW_STOCK_THRESHOLD

      LowStockNotificationJob.perform_later(id)
    end
  end

  private


  
  def invalidate_cache
    Rails.cache.delete("product/#{id}")
    Rails.cache.delete_matched("products/index*")
  end
end
