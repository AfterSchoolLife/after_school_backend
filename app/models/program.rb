class Program < ApplicationRecord
    has_many :schedules
    has_many :carts, as: :item
    validates :title, presence: true, uniqueness: true
    validates :description, presence: true
end
