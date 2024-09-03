class ConvertStringToArrayOfStrings < ActiveRecord::Migration[7.0]
  def change
    # First, add a new column with the desired type
    add_column :schedules, :days_temp, :string, array: true, default: []

    # Copy the data from the old column to the new column with the correct type
    execute <<-SQL
      UPDATE schedules
      SET days_temp = string_to_array(days, ',')
    SQL

    # Remove the old column
    remove_column :schedules, :days

    # Rename the new column to the old column's name
    rename_column :schedules, :days_temp, :days
  end
end