class ChangeDaysFromNumberToCharInSchedules < ActiveRecord::Migration[7.1]
  def change
    change_column :schedules, :days, :string
  end
end
