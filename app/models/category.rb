class Category < ApplicationRecord
  audited

  # NOTE: No dependent option is specified on has_many :products. Consider whether deleting
  # a category should restrict, nullify, or cascade to products.

  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
