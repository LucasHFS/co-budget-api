class MakeUserEmailNotNullable < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :email, :string, null: true, default: ""
    add_column :users, :address, :string
    add_column :users, :gps_link, :string
  end

  def down
    change_column :users, :email, :string, null: false, default: ""
    remove_column :users, :address
    remove_column :users, :gps_link
  end
end
