class AddColumnsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :image_url, :text
  end
end
