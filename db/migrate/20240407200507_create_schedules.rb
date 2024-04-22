class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.integer :duration
      t.string :days
      t.time :start_time
      t.time :end_time
      t.date :start_date
      t.date :end_date
      t.string :age_group
      t.decimal :price
      t.boolean :is_active
      t.references :school, null: false, foreign_key: true
      t.references :program, null: false, foreign_key: true

      t.timestamps
    end
  end
end
