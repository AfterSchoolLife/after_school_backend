class AddFirstNameAndLastNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :parent_1_name, :string
    add_column :users, :parent_2_name, :string
    add_column :users, :parent_1_phone_number, :string
    add_column :users, :parent_2_phone_number, :string
    add_column :users, :emergency_1_name, :string
    add_column :users, :emergency_2_name, :string
    add_column :users, :emergency_1_relation, :string
    add_column :users, :emergency_2_relation, :string
    add_column :users, :emergency_1_phone_number, :string
    add_column :users, :emergency_2_phone_number, :string
  end
end
