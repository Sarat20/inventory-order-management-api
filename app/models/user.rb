class User < ApplicationRecord
  include AASM

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  include Devise::JWT::RevocationStrategies::JTIMatcher

  audited

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  enum :role, {
    admin: 0,
    staff: 1
  }

 
  enum :status, {
    active: 0,
    inactive: 1,
    terminated: 2
  }

  before_validation :set_default_status_and_role

  aasm column: :status, enum: true do
    state :active, initial: true
    state :inactive
    state :terminated

    event :activate do
      transitions from: [:inactive], to: :active
    end

    event :deactivate do
      transitions from: [:active], to: :inactive
    end

    event :terminate do
      transitions from: [:active, :inactive], to: :terminated
    end
  end

  private

  # NOTE: These defaults are also defined at the database level (role: default 1, status: default 0).
  # Consider whether both layers of defaults are necessary, or if this could lead to confusion
  # about the source of truth.
  def set_default_status_and_role
    self.role ||= "staff"
    self.status ||= "active"
  end
end
