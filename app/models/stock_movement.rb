class StockMovement < ApplicationRecord
  belongs_to :reference, polymorphic: true
  belongs_to :product

  # NOTE: Using a string-based inclusion validation is fine, but consider whether an enum would
  # provide better type safety and query convenience (e.g., StockMovement.in, StockMovement.out).
  validates :movement_type, inclusion: { in: %w[in out] }
end
