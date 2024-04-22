class RemoveDurationFromSchedules < ActiveRecord::Migration[7.1]
  def change
    remove_column :schedules, :duration
  end
end
