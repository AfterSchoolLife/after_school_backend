class Schedule < ApplicationRecord
  belongs_to :school
  belongs_to :program
  validates :days, presence: true
  validates :days, inclusion: { in: %w(Monday Tuesday Wednesday Thursday Friday),message: "%{value} is not a valid day" }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :age_group, presence: true
  validates :price, presence: true
  validates :school_id, presence: true
  validates :program_id, presence: true
  validates :program_id, uniqueness: { scope: [:program_id, :days, :start_time, :end_time, :start_date, :end_date, :age_group, :price], message: "combination must be unique" }
end
