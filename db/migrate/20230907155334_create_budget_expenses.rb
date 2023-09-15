class CreateBudgetExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :budget_expenses, id:false do |t|
      t.belongs_to :budget
      t.belongs_to :expense
    end
  end
end
