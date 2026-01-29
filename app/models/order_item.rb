class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  before_validation :set_price_from_product, on: :create

  private

  def set_price_from_product
    self.price ||= product.price if product
  end
end
