# frozen_string_literal: true

json.budgets do |json|
  json.array! @budgets, partial: 'budget', as: :budget
end
