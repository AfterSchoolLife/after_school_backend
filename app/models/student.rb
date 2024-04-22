class Student < ApplicationRecord
    belongs_to :user
    validates :firstname, presence: true
    validates :lastname, presence: true
    validates :age, presence: true
    validates :grade, presence: true
    validates :pickup, presence: true
    validates :address, presence: true
    validates :city, presence: true
    validates :state, presence: true
    validates :zip, presence: true
    validates :user_id, presence: true
    validates :user_id, uniqueness: { scope: [:firstname, :user_id], message: "combination must be unique" }
end
