class AddCountryToAll < ActiveRecord::Migration[7.1]
  def change
    add_column :programs, :country, :string, null: false
    add_column :schools, :country, :string, null: false
    add_column :schedules, :country, :string, null: false
    add_column :products, :country, :string, null: false
  end
end
