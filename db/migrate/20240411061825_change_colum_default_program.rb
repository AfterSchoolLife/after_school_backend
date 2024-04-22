class ChangeColumDefaultProgram < ActiveRecord::Migration[7.1]
  def change
    change_column_default :programs, :is_active, from: nil, to: true
    change_column_default :schools, :is_active, from: nil, to: true
  end
end
