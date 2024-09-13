class AddNoClassDatesToSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :schedules, :no_class_dates, :date, array: true, default: []
  end
end

