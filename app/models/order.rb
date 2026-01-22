class Order < ApplicationRecord

  include AASM

  
  belongs_to :customer
  
 
  audited associated_with: :customer

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :stock_movements, as: :reference, dependent: :destroy

  accepts_nested_attributes_for :order_items, allow_destroy: true

  before_validation :calculate_total

  after_commit :enqueue_confirmation, on: :create

  validates :status, presence: true
  validate :must_have_items
  
  aasm column: "status" do
    state :pending, initial: true
    state :confirmed
    state :shipped
    state :cancelled

    event :confirm do
      transitions from: :pending, to: :confirmed, after: :handle_confirm
    end

    event :ship do
      transitions from: :confirmed, to: :shipped
    end

    event :cancel do
      transitions from: %i[pending confirmed], to: :cancelled
    end
  end

  private

  def handle_confirm
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
    end
  end

  def enqueue_confirmation
    OrderConfirmationJob.perform_later(id)
  end

  def must_have_items
    errors.add(:base, "Order must have at least one item") if order_items.empty?
  end

 

  def calculate_total
    self.total = order_items.sum do |item|
      item.product.price * item.quantity
    end
  end
end
