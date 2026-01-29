class Customer < ApplicationRecord
  audited

  has_many :orders, dependent: :restrict_with_error

  validates :name, presence: true
  # NOTE: Consider adding a database-level unique index on email for additional
  # protection against race conditions (model validation alone can have edge cases).
  validates :email, presence: true, uniqueness: true
end
