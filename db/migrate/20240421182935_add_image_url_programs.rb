class AddImageUrlPrograms < ActiveRecord::Migration[7.1]
  def change
    add_column :programs, :image_url, :text
  end
end
