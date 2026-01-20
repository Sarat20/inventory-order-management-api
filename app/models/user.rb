class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
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
