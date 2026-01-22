class Category < ApplicationRecord
    audited

    
    has_many :products
    validates :name, presence: true , uniqueness: true
end
