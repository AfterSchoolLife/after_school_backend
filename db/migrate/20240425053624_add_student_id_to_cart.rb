class AddStudentIdToCart < ActiveRecord::Migration[7.1]
  def change
    add_reference :carts, :student, type: :bigint, null: false, foreign_key: true
  end
end
