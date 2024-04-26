class User < ApplicationRecord
  has_many :student
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  validates :parent_1_name, presence: true
  validates :parent_1_phone_number, presence: true
  validates :parent_1_relation, presence: true
  validates :emergency_1_name, presence: true
  validates :emergency_1_relation, presence: true
  validates :emergency_1_phone_number, presence: true
  validates :emergency_1_phone_number, presence: true
  validates :country, presence: true
  validates :country, inclusion: { in: %w(usa canada),message: "%{value} is not a valid country" }
end