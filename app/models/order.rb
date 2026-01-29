class Order < ApplicationRecord
  include AASM

  belongs_to :customer

  audited associated_with: :customer

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :stock_movements, as: :reference, dependent: :destroy

  accepts_nested_attributes_for :order_items, allow_destroy: true

  before_validation :set_item_prices, on: :create
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
    end

    event :ship do
      transitions from: :confirmed, to: :shipped
    end

    event :cancel do
      transitions from: %i[pending confirmed], to: :cancelled
    end
  end

  # =========================
  # BUSINESS LOGIC
  # =========================

  # NOTE:
  # We override confirm! so that *all* confirmations ALWAYS go through stock checking.
  # This prevents someone from accidentally calling AASM's confirm! and bypassing inventory logic.
  def confirm!
    confirm_with_stock_check!
  end

  # NOTE:
  # This method:
  # - Locks products to avoid race conditions
  # - Checks stock safely
  # - Deducts stock
  # - Creates stock movement records
  # - Changes order state atomically inside a transaction
  def confirm_with_stock_check!
    raise "Order cannot be confirmed in its current state" unless may_confirm?

    ActiveRecord::Base.transaction do
      order_items.each do |item|
        product = item.product.lock!

        if product.quantity < item.quantity
          raise StandardError, "Insufficient stock"
        end

        product.update!(quantity: product.quantity - item.quantity)

        stock_movements.create!(
          product: product,
          quantity: item.quantity,
          movement_type: "out"
        )
      end

      # NOTE:
      # We update the status directly instead of calling AASM's confirm!
      # to avoid recursion and to keep this transaction fully controlled here.
      update!(status: "confirmed")
    end
  end

  # NOTE: This method is currently unused — consider removing to avoid dead code.
  # If kept for future use (e.g., pre-check APIs), add tests to ensure it stays in sync
  # with the actual stock logic in confirm_with_stock_check!
  def has_sufficient_stock?
    order_items.all? do |item|
      item.product.quantity >= item.quantity
    end
  end

  # =========================
  # CALLBACKS & VALIDATIONS
  # =========================

  def enqueue_confirmation
    OrderConfirmationJob.perform_later(id)
  end

  def must_have_items
    errors.add(:base, "Order must have at least one item") if order_items.empty?
  end

  # NOTE:
  # We assume item.price is always present because OrderItem enforces it.
  # If that validation is ever removed, this method must be updated.
  def calculate_total
    self.total = order_items.sum { |item| item.price * item.quantity }
  end

  # NOTE:
  # Price is copied from product at creation time to avoid future price changes
  # affecting historical orders.
  def set_item_prices
    order_items.each do |item|
      item.price ||= item.product.price
    end
  end
end
