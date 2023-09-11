class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price_in_cents, default: 0, null: false

      t.timestamps
    end
  end
end
