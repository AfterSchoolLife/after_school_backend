class Candidate < ApplicationRecord
    validates :firstname, presence:true
    validates :lastname, presence:true
    validates :email, presence: true, uniqueness: true
    validates :skills, presence:true
    validates :phonenumber, presence:true
    validates :skills, presence:true
    validates :about, presence:true
end
