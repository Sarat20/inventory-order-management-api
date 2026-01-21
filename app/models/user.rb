class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  

  include Devise::JWT::RevocationStrategies::JTIMatcher

  enum :role, {
    admin: 0,
    staff: 1
  }

  enum :status, {
    active: 0,
    inactive: 1
  }
  def set_defaults
    self.role ||= "staff"
    self.status ||= "active"
  end
end
