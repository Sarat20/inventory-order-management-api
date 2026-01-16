class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  enum role: {
    admin: 0,
    staff: 1
  }

  enum status: {
    active: 0,
    inactive: 1
  }
end
