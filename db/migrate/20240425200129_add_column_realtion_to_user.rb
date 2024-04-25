class AddColumnRealtionToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :parent_1_relation, :string
    add_column :users, :parent_2_relation, :string
  end
end
