class CreateBudgetTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :budget_transactions, id:false do |t|
      t.belongs_to :budget
      t.belongs_to :transaction
    end
  end
end
