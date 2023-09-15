class CreateBudgets < ActiveRecord::Migration[7.0]
  def change
    create_table :budgets do |t|
      t.string :name, null: false
      t.integer :total_payable_in_cents, default: 0, null: false
      t.integer :balance_to_pay_in_cents, default: 0, null: false
      t.timestamps
    end
  end
end
