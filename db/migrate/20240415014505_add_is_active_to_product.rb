class AddIsActiveToProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :is_active, :boolean
    change_column_default :products, :is_active, from: nil, to: true
  end
end
