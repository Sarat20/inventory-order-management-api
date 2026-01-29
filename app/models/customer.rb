class Customer < ApplicationRecord
  audited

  # NOTE: The Customer model has auditing and validations but no has_many :orders association.
  # Since orders belong_to :customer, declaring the inverse helps with eager loading and
  # makes the relationship explicit.


  has_many :orders, dependent: :restrict_with_error

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
