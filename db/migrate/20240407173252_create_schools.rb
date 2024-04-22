class CreateSchools < ActiveRecord::Migration[7.1]
  def change
    create_table :schools do |t|
      t.string :title
      t.text :address

      t.timestamps
    end
  end
end
