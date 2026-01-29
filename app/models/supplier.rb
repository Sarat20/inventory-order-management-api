class Supplier < ApplicationRecord
  audited

  has_many :products, dependent: :destroy

  validates :name, presence: true
  # NOTE: Consider adding a database-level unique index on email for additional
  # protection against race conditions (model validation alone can have edge cases).
  validates :email, presence: true, uniqueness: true
end
