class Order < ApplicationRecord
  belongs_to :customer

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :stock_movements, as: :reference

  accepts_nested_attributes_for :order_items, allow_destroy: true

  before_validation :set_default_status, on: :create

  validates :status, presence: true
  validate :must_have_items


  def confirm!
    ActiveRecord::Base.transaction do
      order_items.each do |item|
        product = item.product.lock!

        if product.quantity < item.quantity
          raise ActiveRecord::Rollback, "Insufficient stock"
        end

        product.decrement!(:quantity, item.quantity)

        stock_movements.create!(
          product: product,
          quantity: item.quantity,
          movement_type: "out"
        )
      end

      update!(status: "confirmed")
    end
  end

  def ship!
    update!(status: "shipped")
  end

  def cancel!
    update!(status: "cancelled")
  end

  private

 

  def must_have_items
    errors.add(:base, "Order must have at least one item") if order_items.empty?
  end

  def set_default_status
    self.status ||= "pending"
  end
end
