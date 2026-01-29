class StockMovement < ApplicationRecord
  belongs_to :reference, polymorphic: true
  belongs_to :product

  enum movement_type: {
    in: "in",
    out: "out"
  }

  validates :movement_type, presence: true
end
