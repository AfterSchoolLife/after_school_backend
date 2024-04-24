class RemoveQuantityFromCarts < ActiveRecord::Migration[7.1]
  def change
    remove_column :carts, :quantity, :integer
  end
end
