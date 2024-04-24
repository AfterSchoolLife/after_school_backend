class RenameTypeToPurchasedType < ActiveRecord::Migration[7.1]
  def change
    rename_column :purchaseds, :type, :cart_type
  end
end
