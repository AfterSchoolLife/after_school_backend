class Product < ApplicationRecord
    has_many :carts, as: :item
    validates :title, presence: true, uniqueness: true
    validates :description, presence: true
    validates :price, presence: true
end
