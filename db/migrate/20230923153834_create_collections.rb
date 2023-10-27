class CreateCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :collections do |t|
      t.integer :kind, null: false, default: 1

      t.timestamps
    end

    change_table :transactions do |t|
      t.references :collection, foreign_key: true
    end
  end
end
