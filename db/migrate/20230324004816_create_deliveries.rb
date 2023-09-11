class CreateDeliveries < ActiveRecord::Migration[7.0]
  def change
    create_table :deliveries do |t|
      t.references :order, null: false, foreign_key: true
      t.references :sale_event, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.string :state, null: false, default: 'pending'
      t.string :delivery_address
      t.datetime :delivered_at
      t.string :instructions

      t.timestamps
    end
  end
end
