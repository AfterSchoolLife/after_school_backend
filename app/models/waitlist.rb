class Waitlist < ApplicationRecord
  belongs_to :schedule
  belongs_to :student
  belongs_to :user
  validates :user_id, presence: true
  validates :student_id, presence: true
  validates :schedule_id, presence: true
  validates :schedule_id, uniqueness: { scope: [:student_id, :user_id, :schedule_id], message: "User is already on the waitlist for this schedule" }
end
