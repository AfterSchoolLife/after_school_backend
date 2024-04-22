class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.string :firstname
      t.string :lastname
      t.integer :age
      t.string :grade
      t.string :pickup
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
