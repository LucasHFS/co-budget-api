class AddNameToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :reference_point, :string
    add_column :users, :district, :string
    add_column :users, :role, :integer, default: 1, null: false
  end
end
