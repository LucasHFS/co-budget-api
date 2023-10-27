# frozen_string_literal: true

json.call(transaction, :id, :name, :price, :kind)
json.status I18n.t("activerecord.attributes.transaction.statuses.#{transaction.status}")
json.dueAt transaction.due_at
json.budgetId transaction.budget_id
json.transactionType transaction.transaction_type
