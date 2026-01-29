class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }

  # NOTE: There's no validation for price presence, but Order#calculate_total relies on item.price.
  # The controller sets this before save, but if an OrderItem is created through other means
  # (console, seeds, tests), the total calculation could be affected.

  
  validates :price, presence: true, numericality: { greater_than: 0 }

  before_validation :set_price_from_product, on: :create

  private

  def set_price_from_product
    self.price ||= product.price if product
  end
end
