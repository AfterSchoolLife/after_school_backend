class AddIsActiveToProgram < ActiveRecord::Migration[7.1]
  def change
    add_column :programs, :is_active, :boolean
    add_column :schools, :is_active, :boolean
    change_column_default :programs, :is_active, from: nil, to: true
    change_column_default :schools, :is_active, from: nil, to: true
  end
end
