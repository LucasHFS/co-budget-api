class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :budget, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :price_in_cents, default: 0, null: false
      t.date :due_at, null: false
      t.integer :status, null: false, default: 1
      t.integer :kind, null: false, default: 1
      t.integer :transaction_type, null: false, default: 1
      t.integer :installment_number, default: 1

      t.timestamps
    end

    add_index :transactions, :status
    add_index :transactions, :kind
    add_index :transactions, :transaction_type
  end
end
