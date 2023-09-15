class BudgetExpense < ApplicationRecord
  belongs_to :budget
  belongs_to :expense
end
