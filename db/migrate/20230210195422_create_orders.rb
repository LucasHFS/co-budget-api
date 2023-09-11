class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.belongs_to :user, foreign_key: true
      t.integer "price_in_cents", default: 0, null: false
      t.timestamps
    end
  end
end
