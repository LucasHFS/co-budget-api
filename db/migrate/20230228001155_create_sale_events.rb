class CreateSaleEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :sale_events do |t|
      t.date :date
      t.string :name

      t.timestamps
    end
  end
end
