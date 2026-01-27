class Customer < ApplicationRecord
    audited
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
end
