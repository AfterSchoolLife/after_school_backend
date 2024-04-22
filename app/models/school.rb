class School < ApplicationRecord
    has_many :schedules
    validates :name, presence: true, uniqueness: { scope: :address }
    validates :address, presence: true
end
