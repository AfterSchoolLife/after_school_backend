class CreateCandidates < ActiveRecord::Migration[7.1]
  def change
    create_table :candidates do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :phonenumber
      t.text :about
      t.text :skills

      t.timestamps
    end
  end
end
