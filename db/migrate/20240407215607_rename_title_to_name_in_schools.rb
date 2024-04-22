class RenameTitleToNameInSchools < ActiveRecord::Migration[7.1]
  def change
    rename_column :schools, :title, :name
  end
end
