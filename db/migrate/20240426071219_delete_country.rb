class DeleteCountry < ActiveRecord::Migration[7.1]
  def change
    remove_column :programs, :country
  end
end
