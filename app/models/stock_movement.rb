class StockMovement < ApplicationRecord
  belongs_to :reference, polymorphic: true
  belongs_to :product

  validates :movement_type, inclusion: { in: %w[in out] }
end
