class ChangeColumDefaultSchedules < ActiveRecord::Migration[7.1]
  def change
    change_column_default :schedules, :is_active, from: nil, to: true
  end
end
