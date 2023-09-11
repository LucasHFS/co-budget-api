class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.integer :quantity
      t.integer :unit_price_in_cents

      # relation
      t.belongs_to :order, foreign_key: true
      t.belongs_to :product, foreign_key: true

      t.timestamps
    end
  end
end
