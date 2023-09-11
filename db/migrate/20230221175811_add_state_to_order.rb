class AddStateToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :state, :string, null: false, default: 'pending'
  end
end
