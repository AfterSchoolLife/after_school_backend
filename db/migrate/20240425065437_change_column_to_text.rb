class ChangeColumnToText < ActiveRecord::Migration[7.1]
  def change
    change_column :purchaseds, :purchase_uuid, :string
  end
end
