class AddSaleEventIdToOrder < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :sale_event, foreign_key: true
  end
end
