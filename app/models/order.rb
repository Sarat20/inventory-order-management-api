class Order < ApplicationRecord
  belongs_to :customer

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :stock_movements, as: :reference, dependent: :destroy

  accepts_nested_attributes_for :order_items, allow_destroy: true

  before_validation :set_default_status, on: :create
  before_validation :calculate_total

  after_commit :enqueue_confirmation, on: :create

  validates :status, presence: true
  validate :must_have_items


  def confirm!
    ActiveRecord::Base.transaction do
      order_items.each do |item|
        product = item.product.lock!

        if product.quantity < item.quantity
          raise ActiveRecord::Rollback, "Insufficient stock"
        end

        product.update!(quantity: product.quantity - item.quantity)

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

  def enqueue_confirmation
    OrderConfirmationJob.perform_later(id)
  end

  def must_have_items
    errors.add(:base, "Order must have at least one item") if order_items.empty?
  end

  def set_default_status
    self.status ||= "pending"
  end

  def calculate_total
    self.total = order_items.sum do |item|
      item.product.price * item.quantity
    end
  end
end
