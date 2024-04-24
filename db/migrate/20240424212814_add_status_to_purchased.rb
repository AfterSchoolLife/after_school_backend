class AddStatusToPurchased < ActiveRecord::Migration[7.1]
  def change
    add_column  :purchaseds,:status, :string
  end
end
