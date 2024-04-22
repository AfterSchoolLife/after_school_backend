class ChangeDaysFromCharToNumberInSchedules < ActiveRecord::Migration[7.1]
  def change
    change_column :schedules, :days, :'integer USING CAST(days AS integer)'
  end
end
