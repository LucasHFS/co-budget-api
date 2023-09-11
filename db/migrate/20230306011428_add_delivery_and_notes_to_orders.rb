class AddDeliveryAndNotesToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :is_delivery, :boolean, null: false, default: true
    add_column :orders, :notes, :text, null: false, default: ''
  end
end
