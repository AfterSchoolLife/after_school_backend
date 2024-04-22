class RenameTypeToCartType < ActiveRecord::Migration[7.1]
  def change
    rename_column :carts, :type, :cart_type
  end
end
