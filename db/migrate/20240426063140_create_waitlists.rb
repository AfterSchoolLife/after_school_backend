class CreateWaitlists < ActiveRecord::Migration[7.1]
  def change
    create_table :waitlists do |t|
      t.references :schedule, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.references :user,type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
