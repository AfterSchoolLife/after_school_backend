class Waitlist < ApplicationRecord
  belongs_to :schedule
  belongs_to :student
  belongs_to :user
end
