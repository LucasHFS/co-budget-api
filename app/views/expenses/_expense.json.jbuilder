# frozen_string_literal: true

json.call(expense, :id, :name, :price, :kind)
json.status I18n.t("activerecord.attributes.expense.statuses.#{expense.status}")
json.dueAt expense.due_at
json.budgetId expense.budget_id
