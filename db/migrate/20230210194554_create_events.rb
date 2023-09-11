class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.date :date_at

      t.timestamps
    end
  end
end
