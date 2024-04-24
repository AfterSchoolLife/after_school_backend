class AddColumnToSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :schedules, :teacher_name, :string
    add_column :schedules, :cost_of_teacher, :decimal
    add_column :schedules, :facility_rental, :decimal
    add_column :schedules, :total_available, :integer
    add_column :schedules, :currently_available, :integer
    add_column :schedules, :created_by, :uuid
    add_column :programs, :created_by, :uuid
    add_column :schools, :created_by, :uuid
    add_column :products, :created_by, :uuid
  end
end
