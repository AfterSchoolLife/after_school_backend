class CreatePurchased < ActiveRecord::Migration[7.1]
  def change
    create_table :purchaseds do |t|
      t.references :user,type: :uuid, null: false, foreign_key: true
      t.references :student,null: false, foreign_key: true
      t.belongs_to :schedule, foreign_key: true
      t.belongs_to :product, foreign_key: true
      t.string :type
      t.uuid :purchase_uuid

      t.timestamps
    end
  end
end
