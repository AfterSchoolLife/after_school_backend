class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.references :user,type: :uuid, null: false, foreign_key: true
      t.belongs_to :schedule, foreign_key: true
      t.belongs_to :product, foreign_key: true
      t.integer :quantity
      t.string :type

      t.timestamps
    end
  end
end
