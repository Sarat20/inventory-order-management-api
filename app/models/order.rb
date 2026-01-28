class Order < ApplicationRecord
  include AASM

  belongs_to :customer

  audited associated_with: :customer

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :stock_movements, as: :reference, dependent: :destroy

  accepts_nested_attributes_for :order_items, allow_destroy: true

  before_save :calculate_total

  after_commit :enqueue_confirmation, on: :create

  validates :status, presence: true
  validate :must_have_items

  aasm column: "status" do
    state :pending, initial: true
    state :confirmed
    state :shipped
    state :cancelled

    event :confirm do
      transitions from: :pending, to: :confirmed
      after do
        handle_confirm
      end
    end

    event :ship do
      transitions from: :confirmed, to: :shipped
    end

    event :cancel do
      transitions from: %i[pending confirmed], to: :cancelled
    end
  end

  # NOTE: This method performs a stock check without database locks. The lock happens later
  # in handle_confirm, but a race condition could occur between this check and the actual
  # confirmation. Consider moving the lock acquisition earlier or combining with handle_confirm.
  def has_sufficient_stock?
    order_items.all? do |item|
      item.product.quantity >= item.quantity
    end
  end

  private

  # NOTE: ActiveRecord::Rollback silently aborts the transaction but doesn't raise outside of it.
  # The method will still complete and the state machine may be left in an inconsistent state.
  # Consider using a non-silently-caught exception or returning an error tuple that the caller can act on.
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

  # NOTE: Using item.price.to_f suggests price might sometimes be nil. OrderItem doesn't validate
  # price presence, which could silently calculate an incorrect total. Consider validating price
  # presence or using a safer default.
  def calculate_total
    self.total = order_items.sum { |item| item.price.to_f * item.quantity }
  end
end
